# 🎤 Interview Q&A — Lab 16: Database Configuration with Ansible (MySQL + PostgreSQL)

## 1) Why automate database installation and configuration with Ansible?
Databases are high-impact services. Automation ensures:
- consistent installs across hosts
- repeatable configuration (no drift)
- faster provisioning
- auditable “infrastructure as code” changes
- fewer human errors that can cause outages or security issues

---

## 2) Why did you split inventory into `mysql_servers` and `postgresql_servers`?
Because each database uses different packages, services, ports, and configuration files. Group separation allows:
- targeted playbooks (MySQL vs PostgreSQL)
- different variables and tasks per DB type
- cleaner role branching logic

---

## 3) What is the advantage of using `community.mysql` and `community.postgresql` modules instead of shell commands?
Modules provide:
- idempotency (safe reruns)
- structured parameters (less fragile than string commands)
- better error messages
- proper privilege handling and state management

---

## 4) Why did you install `python3-pymysql` and `python3-psycopg2` on the targets?
These Python libraries allow Ansible database modules to communicate with the DB engines:
- `python3-pymysql` → MySQL module support
- `python3-psycopg2` → PostgreSQL module support

Without them, module-based DB tasks typically fail.

---

## 5) What security improvements were applied to MySQL in this lab?
Key hardening steps included:
- removing anonymous users
- removing the test database
- disabling `local-infile` (prevents risky file imports)
- enabling `skip-show-database` behavior (reduces DB enumeration exposure)
- tightening file permissions on key config/log files

---

## 6) What does changing MySQL `bind-address` to `0.0.0.0` do?
It allows MySQL to listen on all interfaces (enables remote connections).  
This is useful for multi-tier apps but must be controlled with:
- firewall rules
- least privilege DB accounts
- network segmentation

---

## 7) How did you enable PostgreSQL remote access?
Two main steps:
1) Set `listen_addresses = '*'` so PostgreSQL listens on network interfaces  
2) Updated `pg_hba.conf` with a host rule using `md5` auth for remote clients  
Then restarted PostgreSQL to apply changes.

---

## 8) Why does Ubuntu show PostgreSQL as “active (exited)”?
On Ubuntu, `postgresql.service` is a wrapper meta-service.  
The actual running database is managed by the cluster unit (versioned services), so seeing “active (exited)” for the wrapper is normal.

---

## 9) What is `pg_hba.conf` and why is it important?
`pg_hba.conf` controls PostgreSQL client authentication rules:
- which users can connect
- from which networks
- using which authentication methods  
It’s a core security control in PostgreSQL environments.

---

## 10) What is the purpose of Fail2ban in this lab?
Fail2ban monitors authentication logs and blocks IPs that show brute-force behavior.  
Here it was configured for SSH to reduce the risk of repeated login attempts against the DB servers.

---

## 11) Why did you configure unattended upgrades?
Because database servers often run long-term. Automatic security updates help ensure:
- vulnerability patches are applied
- baseline hardening is maintained
- less manual patching burden

In production this is usually paired with change windows and testing policies.

---

## 12) Why implement backups using scripts + cron?
It demonstrates a simple, widely used approach:
- produce timestamped compressed dumps
- enforce retention cleanup
- schedule via cron for predictable operation  
In real-world environments, this can later be extended to object storage, encryption, and monitoring.

---

## 13) What did the health/monitoring scripts verify?
They validated:
- memory and disk usage
- uptime and load
- DB ports listening (3306/5432)
- service status checks (mysql/postgresql)
- basic DB activity stats (PostgreSQL pg_stat views, MySQL processlist)

---

## 14) Why build an Ansible role instead of keeping everything as playbooks?
Roles make automation reusable and structured:
- defaults and variables in one place
- tasks broken into logical files
- templates and handlers packaged cleanly
- can be reused for multiple servers/environments consistently

This is closer to enterprise automation patterns.

---

## 15) How did you test that the role works correctly?
I created role-based playbooks:
- `use-role-mysql.yml`
- `use-role-postgresql.yml`

Then validated outputs:
- role branching worked by `database_type`
- handlers ran when configs changed
- `db-monitor.sh` script existed and produced expected port/listener output
