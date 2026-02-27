# 🛠️ Troubleshooting Guide — Lab 16: Database Configuration with Ansible (MySQL + PostgreSQL)

> This document captures common issues and fixes when automating database provisioning with Ansible, including module dependencies, connectivity, authentication, and service validation.

---

## 🧩 Issue 1: Hosts Unreachable / Ping Fails

### ❗ Problem
- `UNREACHABLE!`
- SSH timeout / permission denied
- `ansible -m ping` fails

### ✅ Cause
- wrong `ansible_user`
- wrong target IPs
- missing/incorrect SSH key path
- security group / firewall blocks SSH (22)

### ✅ Fix
Check inventory correctness:
```bash
cat inventory.ini
````

Test host reachability:

```bash
ansible -i inventory.ini database_servers -m ping
```

Try direct SSH:

```bash
ssh -i ~/.ssh/lab_key ubuntu@10.0.1.10
ssh -i ~/.ssh/lab_key ubuntu@10.0.1.11
```

---

## 🧩 Issue 2: Database Modules Fail (Missing Collections)

### ❗ Problem

Playbook errors like:

* `ERROR! couldn't resolve module/action 'mysql_user'`
* `community.mysql.mysql_user not found`
* `community.postgresql.postgresql_db not found`

### ✅ Cause

Required collections not installed on the control node.

### ✅ Fix

Check installed collections:

```bash
ansible-galaxy collection list | egrep 'community\.mysql|community\.postgresql|community\.general' || true
```

Install required collections:

```bash
ansible-galaxy collection install community.mysql community.postgresql community.general
```

---

## 🧩 Issue 3: MySQL Tasks Fail (Python Driver Missing)

### ❗ Problem

Errors like:

* `PyMySQL module not found`
* MySQL modules fail even though MySQL is installed

### ✅ Cause

The target host lacks `python3-pymysql`.

### ✅ Fix

Ensure it’s installed on MySQL host:

```bash
ansible -i inventory.ini mysql_servers -m apt -a "name=python3-pymysql state=present update_cache=yes" --become
```

---

## 🧩 Issue 4: PostgreSQL Tasks Fail (psycopg2 Missing)

### ❗ Problem

Errors like:

* `psycopg2 is required`
* PostgreSQL modules cannot connect

### ✅ Cause

Target host missing `python3-psycopg2`.

### ✅ Fix

Install dependency:

```bash
ansible -i inventory.ini postgresql_servers -m apt -a "name=python3-psycopg2 state=present update_cache=yes" --become
```

---

## 🧩 Issue 5: MySQL Root Password / Authentication Issues

### ❗ Problem

MySQL commands fail:

* `Access denied for user 'root'@'localhost'`
* root cannot authenticate with password

### ✅ Cause

Ubuntu MySQL often uses socket authentication by default, and password configuration must be applied correctly.

### ✅ Fix

Use unix socket login when setting root password (as done in playbook):

* `login_unix_socket: /var/run/mysqld/mysqld.sock`

Verify DB access:

```bash
ansible -i inventory.ini mysql_servers -m shell -a "mysql -u root -p'SecureRootPass123!' -e 'SHOW DATABASES;'" --become
```

---

## 🧩 Issue 6: PostgreSQL Service Looks “active (exited)”

### ❗ Problem

`systemctl status postgresql` shows:

* `active (exited)`

### ✅ Cause

On Ubuntu, `postgresql.service` is a wrapper meta-service; the real cluster runs under versioned cluster units.

### ✅ Fix / Verification

Validate Postgres using psql:

```bash
ansible -i inventory.ini postgresql_servers -m shell -a "sudo -u postgres psql -c '\l'" --become
```

And confirm listening port:

```bash
ansible -i inventory.ini postgresql_servers -m shell -a "ss -tuln | grep :5432" --become
```

---

## 🧩 Issue 7: Remote Access Not Working (MySQL / PostgreSQL)

### ❗ Problem

Clients cannot connect remotely.

### ✅ Cause (Common)

* DB not listening on all interfaces
* firewall blocks the port
* Postgres `pg_hba.conf` denies remote connections
* cloud networking rules block access

### ✅ Fix (MySQL)

Check bind-address:

```bash
ansible -i inventory.ini mysql_servers -m shell -a "grep -E '^bind-address' /etc/mysql/mysql.conf.d/mysqld.cnf" --become
```

Restart:

```bash
ansible -i inventory.ini mysql_servers -m systemd -a "name=mysql state=restarted" --become
```

### ✅ Fix (PostgreSQL)

Confirm listen addresses:

```bash
ansible -i inventory.ini postgresql_servers -m shell -a "sudo -u postgres psql -c \"SHOW listen_addresses;\"" --become
```

Confirm pg_hba includes host rule:

```bash
ansible -i inventory.ini postgresql_servers -m shell -a "sudo grep -n 'host' /etc/postgresql/12/main/pg_hba.conf | head" --become
```

Restart:

```bash
ansible -i inventory.ini postgresql_servers -m systemd -a "name=postgresql state=restarted" --become
```

---

## 🧩 Issue 8: UFW Rules Not Applied / Port Still Closed

### ❗ Problem

Port 3306/5432 not reachable even after allowing rules.

### ✅ Cause

* ufw disabled
* policy blocks incoming
* rules not enabled
* cloud network firewall blocks inbound traffic

### ✅ Fix

Check ufw status:

```bash
ansible -i inventory.ini database_servers -m shell -a "ufw status verbose" --become
```

Enable ufw (careful in production):

```bash
ansible -i inventory.ini database_servers -m shell -a "ufw --force enable" --become
```

Ensure DB ports allowed:

```bash
ansible -i inventory.ini mysql_servers -m shell -a "ufw allow 3306/tcp" --become
ansible -i inventory.ini postgresql_servers -m shell -a "ufw allow 5432/tcp" --become
```

---

## 🧩 Issue 9: Backup Script Fails

### ❗ Problem

Backup script exits with errors:

* mysqldump fails
* permission denied writing backups
* gzip missing

### ✅ Cause

* wrong credentials
* backup directory missing
* missing packages

### ✅ Fix

Verify directory:

```bash
ansible -i inventory.ini database_servers -m shell -a "ls -la /opt/database-backups/" --become
```

Install gzip/cron:

```bash
ansible -i inventory.ini database_servers -m apt -a "name=gzip,cron state=present update_cache=yes" --become
```

Run script manually:

```bash
ansible -i inventory.ini mysql_servers -m shell -a "/usr/local/bin/mysql-backup.sh" --become
ansible -i inventory.ini postgresql_servers -m shell -a "/usr/local/bin/postgresql-backup.sh" --become
```

---

## 🧩 Issue 10: Role Tasks Don’t Run as Expected

### ❗ Problem

Role executes but wrong DB tasks run (or skip unexpectedly).

### ✅ Cause

`database_type` variable not set correctly.

### ✅ Fix

Check role variables in role playbook:

* MySQL: `database_type: "mysql"`
* PostgreSQL: `database_type: "postgresql"`

Re-run:

```bash
ansible-playbook -i inventory.ini playbooks/use-role-mysql.yml
ansible-playbook -i inventory.ini playbooks/use-role-postgresql.yml
```

---

## ✅ Quick Validation Checklist (Post-Run)

```bash
ansible -i inventory.ini database_servers -m ping
ansible -i inventory.ini mysql_servers -m shell -a "systemctl status mysql" --become
ansible -i inventory.ini postgresql_servers -m shell -a "sudo -u postgres psql -c '\l'" --become
ansible -i inventory.ini database_servers -m shell -a "ls -la /opt/database-backups/" --become
ansible -i inventory.ini database_servers -m shell -a "/usr/local/bin/db-health-check.sh" --become
ansible -i inventory.ini database_servers -m shell -a "/usr/local/bin/db-monitor.sh | head -25" --become
```

---
