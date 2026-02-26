# 🛠️ Lab 08: Writing Complex Playbooks — Troubleshooting Guide

> This troubleshooting guide covers the most common issues encountered when deploying a **multi-tier application stack** (MySQL + Apache + PHP app) using **multi-play** and **role-based** Ansible playbooks.

---

## 1) ❌ MySQL service not running on database servers

### ✅ Symptoms
- Playbook fails during MySQL tasks
- DB connectivity tests fail
- MySQL module tasks return errors

### 🔍 Likely Causes
- `mysqld` service not installed or not enabled
- MySQL initialization incomplete
- Service failed due to config error (`/etc/my.cnf`)
- Incorrect socket path or permissions

### ✅ Fix / Validation Steps
#### Check service status
```bash
ansible database_servers -i inventory.ini -m systemd -a "name=mysqld" --become
````

#### Check MySQL logs

```bash
ansible database_servers -i inventory.ini -m shell -a "tail -20 /var/log/mysqld.log" --become
```

#### Restart service manually

```bash
ansible database_servers -i inventory.ini -m systemd -a "name=mysqld state=restarted" --become
```

---

## 2) ❌ Ansible MySQL modules failing (mysql_user / mysql_db)

### ✅ Symptoms

* Tasks like `mysql_user` or `mysql_db` fail
* Errors related to missing Python library

### 🔍 Likely Causes

* Missing MySQL Python dependency (PyMySQL)
* Incorrect login credentials (root password mismatch)
* MySQL service not ready yet (race condition)

### ✅ Fix / Validation Steps

#### Ensure PyMySQL is installed

This lab includes:

* `python3-PyMySQL` installed via yum
  If missing, validate:

```bash
ansible database_servers -i inventory.ini -m yum -a "name=python3-PyMySQL state=present" --become
```

#### Verify MySQL is accepting connections

```bash
ansible database_servers -i inventory.ini -m shell -a "mysqladmin ping" --become
```

---

## 3) ❌ Root password mismatch (unable to login as root)

### ✅ Symptoms

* MySQL ad-hoc test fails
* Playbook cannot create DB/users
* `Access denied for user 'root'@'localhost'`

### 🔍 Likely Causes

* Root password was set previously to a different value
* Multiple playbooks used different credentials (`SecurePass123!` vs `DatabaseRoot123!`)
* Re-running playbooks without aligning variables

### ✅ Fix / Validation Steps

#### Confirm variables in use

* `site.yml` uses: `SecurePass123!`
* `group_vars/database_servers.yml` uses: `DatabaseRoot123!`

✅ Ensure you run deployments consistently using the intended playbook and variable source.

#### Test root login (as used in troubleshooting section)

```bash
ansible database_servers -i inventory.ini -m shell -a "mysql -u root -p'SecurePass123!' -e 'SHOW DATABASES;'" --become
```

If root password differs, update:

* `group_vars/database_servers.yml`
* or reset password safely (lab environment only)

---

## 4) ❌ Web application shows database connection failed

### ✅ Symptoms

* Browser shows connection failure message from PHP
* `dbtest.php` indicates failure
* `uri` returns 200 but content includes error

### 🔍 Likely Causes

* Firewall blocking MySQL port `3306`
* MySQL bind address not listening externally
* Incorrect DB host (wrong inventory hostname)
* Wrong DB user/password

### ✅ Fix / Validation Steps

#### Check firewall on DB servers

```bash
ansible database_servers -i inventory.ini -m shell -a "firewall-cmd --list-all" --become
```

Ensure `3306/tcp` is present.

#### Confirm MySQL listening on 0.0.0.0:3306

```bash
ansible database_servers -i inventory.ini -m shell -a "ss -tlnp | grep 3306" --become
```

#### Confirm MySQL configuration template applied

```bash
ansible database_servers -i inventory.ini -m shell -a "grep -E 'bind-address|port' /etc/my.cnf" --become
```

---

## 5) ❌ Apache not responding on web servers

### ✅ Symptoms

* `uri` module fails
* Cannot reach `http://<web_ip>/mywebapp`
* `curl` fails from control node

### 🔍 Likely Causes

* `httpd` not started or enabled
* Firewall blocking port 80
* Apache config syntax issue in vhost file
* SELinux restrictions (depending on lab image config)

### ✅ Fix / Validation Steps

#### Check Apache service

```bash
ansible web_servers -i inventory.ini -m systemd -a "name=httpd" --become
```

#### Check Apache error logs

```bash
ansible web_servers -i inventory.ini -m shell -a "tail -20 /var/log/httpd/error_log" --become
```

#### Confirm port 80 is listening

```bash
ansible web_servers -i inventory.ini -m shell -a "netstat -tlnp | grep :80" --become
```

---

## 6) ❌ Firewall rules missing (HTTP/MySQL ports blocked)

### ✅ Symptoms

* Services running but unreachable
* `uri` fails from web hosts or control node
* DB connectivity fails from web servers

### 🔍 Likely Causes

* `firewalld` not started
* Rules not applied with `immediate: yes`
* Wrong zone applied

### ✅ Fix / Validation Steps

#### Check firewall status

```bash
ansible all -i inventory.ini -m shell -a "firewall-cmd --list-all" --become
```

#### Enable port 80 (example used in lab)

```bash
ansible web_servers -i inventory.ini -m firewalld -a "port=80/tcp permanent=yes state=enabled immediate=yes" --become
```

#### Validate MySQL port (3306)

```bash
ansible database_servers -i inventory.ini -m firewalld -a "port=3306/tcp permanent=yes state=enabled immediate=yes" --become
```

---

## 7) ❌ Inventory or SSH connectivity issues

### ✅ Symptoms

* Hosts unreachable
* Permission denied errors
* Ansible fails during fact gathering

### 🔍 Likely Causes

* Wrong `ansible_user` in inventory
* Wrong SSH key path
* Security group / network ACL blocks
* DNS resolution issues

### ✅ Fix / Validation Steps

#### Confirm inventory variables

Check `inventory.ini`:

* `ansible_user=ec2-user`
* `ansible_ssh_private_key_file=~/.ssh/id_rsa`

#### Test ping connectivity

```bash
ansible all -i inventory.ini -m ping
```

---

## 8) ❌ Role variables not applying (undefined variable errors)

### ✅ Symptoms

* Errors like: `The task includes an option with an undefined variable`
* Template rendering fails

### 🔍 Likely Causes

* Variable defined in wrong scope (defaults vs group_vars)
* Typo in variable name
* Group name mismatch (`web_servers` vs `webserver`)

### ✅ Fix / Validation Steps

#### Check variable sources

* `roles/*/defaults/main.yml` provides baseline defaults
* `group_vars/*` overrides group-specific values
* Playbook vars override everything (highest precedence)

#### Validate inventory group names match `group_vars` filenames

* `group_vars/web_servers.yml` must match `[web_servers]`
* `group_vars/database_servers.yml` must match `[database_servers]`

---

## ✅ Quick “Known Good” Validation Commands (from this lab)

### Database health checks

```bash
ansible database_servers -i inventory.ini -m systemd -a "name=mysqld" --become
ansible database_servers -i inventory.ini -m shell -a "tail -20 /var/log/mysqld.log" --become
ansible database_servers -i inventory.ini -m shell -a "mysql -u root -p'SecurePass123!' -e 'SHOW DATABASES;'" --become
```

### Web server checks

```bash
ansible web_servers -i inventory.ini -m systemd -a "name=httpd" --become
ansible web_servers -i inventory.ini -m shell -a "tail -20 /var/log/httpd/error_log" --become
ansible web_servers -i inventory.ini -m shell -a "netstat -tlnp | grep :80" --become
```

### Firewall checks

```bash
ansible all -i inventory.ini -m shell -a "firewall-cmd --list-all" --become
```

---
