# 🗄️ Lab 16: Database Configuration with Ansible (MySQL + PostgreSQL)

## 🧾 Lab Summary
In this lab, I automated **database server provisioning and administration** using Ansible across two Ubuntu targets:

- ✅ Installed and configured **MySQL** on `mysql-server`
- ✅ Installed and configured **PostgreSQL** on `postgres-server`
- ✅ Created **databases + users + privileges** using Ansible modules
- ✅ Enabled **remote access** (bind/listen + auth rules) and opened DB ports via UFW
- ✅ Applied **security hardening** (fail2ban, unattended upgrades, DB config hardening)
- ✅ Implemented **backup automation** (scripts + cron + retention)
- ✅ Implemented **health/monitoring scripts**
- ✅ Built a reusable **Ansible role** (`database-management`) to manage MySQL/PostgreSQL consistently

> Environment note: executed in a guided cloud lab environment with a CentOS/RHEL 8 control node and two Ubuntu 20.04 targets.

---

## 🎯 Objectives
By the end of this lab, I was able to:

- Install and configure **MySQL** and **PostgreSQL** remotely using Ansible
- Create databases and users using Ansible database modules
- Implement database security best practices (permissions + access control)
- Write a reusable Ansible **role** for database management
- Apply Infrastructure-as-Code (IaC) practices for database administration
- Troubleshoot common database deployment issues in automation workflows

---

## ✅ Prerequisites
- Linux CLI basics
- YAML familiarity
- Ansible fundamentals (inventory, playbooks, tasks, modules)
- Database concepts (users, schemas, privileges)
- Networking basics (ports, IPs, SSH)

---

## 🧰 Lab Environment
**Control Node**
- CentOS/RHEL 8 with Ansible pre-installed

**Target Nodes**
- Ubuntu 20.04 LTS
  - `mysql-server` (10.0.1.10)
  - `postgres-server` (10.0.1.11)

**Access**
- SSH keys preconfigured
- Sudo privileges available

---

## 📁 Repository Structure (Lab Folder)

```text
lab16-database-configuration-with-ansible/
├── README.md
├── commands.sh
├── output.txt
├── inventory.ini
├── templates/
│   └── my.cnf.j2
├── playbooks/
│   ├── mysql-setup.yml
│   ├── postgresql-setup.yml
│   ├── database-security.yml
│   ├── database-backup.yml
│   ├── database-monitoring.yml
│   ├── use-role-mysql.yml
│   └── use-role-postgresql.yml
└── roles/
    └── database-management/
        ├── defaults/
        │   └── main.yml
        ├── handlers/
        │   └── main.yml
        ├── meta/
        │   └── main.yml
        ├── tasks/
        │   ├── main.yml
        │   ├── mysql.yml
        │   ├── postgresql.yml
        │   ├── security.yml
        │   ├── backup.yml
        │   └── monitoring.yml
        └── templates/
            ├── mysqld.cnf.j2
            ├── mysql-backup.sh.j2
            ├── postgresql-backup.sh.j2
            └── db-monitor.sh.j2
````

---

## 🧩 Tasks Overview (High Level)

### ✅ Task 1: Environment Prep + Inventory

* Verified Ansible installation and host connectivity
* Created a clean project structure
* Built an inventory separating MySQL vs PostgreSQL hosts and grouping them under `database_servers`

### ✅ Task 2: MySQL Setup (Ubuntu)

* Installed MySQL packages (`mysql-server`, `mysql-client`, `python3-pymysql`)
* Set root password (socket auth)
* Removed anonymous users + test DB
* Created databases: `webapp_db`, `inventory_db`
* Created users with scoped privileges
* Enabled remote connectivity (bind-address `0.0.0.0`)
* Opened port `3306/tcp` via UFW

### ✅ Task 3: PostgreSQL Setup (Ubuntu)

* Installed PostgreSQL packages + dependencies (`python3-psycopg2`, `acl`)
* Created users/roles and databases:

  * `ecommerce_db`, `analytics_db`
* Configured `pg_hba.conf` for MD5 auth and remote access
* Set listen_addresses to `*` and tuned `max_connections`
* Granted database privileges per role
* Opened port `5432/tcp` via UFW

### ✅ Task 4: Security Hardening

* Installed and configured `fail2ban` for SSH
* Enabled unattended security updates
* Hardened MySQL config (disabled local infile, symbolic links, hide DB listing behavior)
* Hardened PostgreSQL settings (logging + SSL flag) and tightened file permissions

### ✅ Task 5: Backups + Maintenance

* Created backup directory `/opt/database-backups`
* Created scheduled cron backups:

  * MySQL via `mysqldump | gzip`
  * PostgreSQL via `pg_dumpall | gzip`
* Enforced retention (delete > 7 days)
* Verified backups were generated successfully

### ✅ Task 6: Monitoring + Health Checks

* Installed monitoring utilities (`htop`, `iotop`, `net-tools`)
* Created scripts:

  * generic `db-health-check.sh`
  * `mysql-status.sh`
  * `postgresql-status.sh`
* Verified scripts output and port listeners (`3306`, `5432`)

### ✅ Task 7: Reusable Role (`database-management`)

* Created a role to standardize:

  * installation
  * security hardening
  * backups
  * monitoring
* Built role templates (DB config + backup scripts + monitor script)
* Tested role via:

  * `playbooks/use-role-mysql.yml`
  * `playbooks/use-role-postgresql.yml`
* Validated role outputs (monitor script + handlers firing)

---

## ✅ Verification & Evidence

Validation steps performed (artifacts captured in `output.txt`):

* `ansible ... -m ping` success for both targets
* MySQL:

  * `systemctl status mysql` active/running
  * `SHOW DATABASES;` shows created DBs
* PostgreSQL:

  * `psql -c '\l'` shows created DBs
  * `SHOW log_connections;` verifies hardening setting
* Backups:

  * scripts executed manually and produced `.sql.gz` files
  * `/opt/database-backups/` contains generated backups
* Monitoring:

  * health scripts confirm port listeners and system resource state

---

## 🛡️ Security Notes (Relevant for this Lab)

This lab includes database credentials in variables/scripts for demonstration.
For real projects, store secrets using **Ansible Vault** (or an external secrets manager) and avoid committing plaintext credentials to Git.

---

## ✅ Conclusion

This lab built real-world database automation skills: provisioning, access control, secure configuration, backups, monitoring, and reusable roles. The end result is a repeatable Infrastructure-as-Code workflow that can be applied across environments and scaled safely.

✅ Lab completed successfully
✅ MySQL + PostgreSQL installed, secured, backed up, monitored
✅ Role-based automation ready
