# 🛠️ troubleshooting Guide — Lab 17: Orchestrating Multiple Tasks (Ansible)

> This document lists common issues encountered in multi-playbook orchestration and how to fix them.

---

## 1) ❌ Database Play Fails: Host Unreachable / Ping Failed

### ✅ Symptoms
- `db_ping_result is failed`
- Task: **"Fail if database server unreachable"** triggers

### 🔍 Likely Causes
- Wrong IP in inventory for `db1`
- SSH connectivity issue (key missing/incorrect user)
- Network segmentation / firewall blocking SSH

### ✅ Fix
1. Verify inventory values:
```bash
cat inventory/hosts
````

2. Test connectivity:

```bash
ansible database_servers -i inventory/hosts -m ping
```

3. Verify SSH user/key:

```bash
ansible database_servers -i inventory/hosts -m ping -u centos --private-key ~/.ssh/id_rsa
```

---

## 2) ❌ Web Servers Fail: “Database must be deployed before web servers”

### ✅ Symptoms

* Task fails in `webservers.yml` pre_tasks:

  * **Database must be deployed before web servers**

### 🔍 Likely Causes

* Database play did not run (or failed)
* `database_deployed` fact not set due to service status mismatch
* You ran `--tags webservers` first without deploying DB

### ✅ Fix

1. Run DB phase first:

```bash
ansible-playbook -i inventory/hosts playbooks/site.yml --tags database
```

2. Confirm DB facts exist (quick check using setup/facts):

```bash
ansible db1 -i inventory/hosts -m setup | head
```

3. Confirm MariaDB is active:

```bash
ansible database_servers -i inventory/hosts -m systemd -a "name=mariadb" --become
```

---

## 3) ❌ MySQL Tasks Fail: `mysql_db` or `mysql_user` errors

### ✅ Symptoms

* `mysql_db` fails with socket or connection errors
* `mysql_user` fails due to authentication/plugin issues

### 🔍 Likely Causes

* MariaDB not running
* Missing Python DB driver on managed node (`python3-PyMySQL`)
* Wrong unix socket path

### ✅ Fix

1. Confirm MariaDB service:

```bash
ansible database_servers -i inventory/hosts -m systemd -a "name=mariadb state=started enabled=yes" --become
```

2. Ensure DB driver package is installed:

```bash
ansible database_servers -i inventory/hosts -m yum -a "name=python3-PyMySQL state=present" --become
```

3. Confirm socket path on DB node:

```bash
ansible database_servers -i inventory/hosts -m shell -a "ls -l /var/lib/mysql/mysql.sock" --become
```

---

## 4) ❌ Web Application Not Loading: Apache OK but URL returns 403/404

### ✅ Symptoms

* `http://web1/webapp/` returns 403/404
* Load balancer health checks fail because backend is not responding correctly

### 🔍 Likely Causes

* Wrong DocumentRoot in Apache vhost template
* Missing directory permissions/ownership
* Application folder not created or files missing

### ✅ Fix

1. Validate Apache config:

```bash
ansible web_servers -i inventory/hosts -m shell -a "httpd -t" --become
```

2. Check directory exists:

```bash
ansible web_servers -i inventory/hosts -m shell -a "ls -l /var/www/html/webapp && ls -l /var/www/html/webapp/index.php" --become
```

3. Check ownership:

```bash
ansible web_servers -i inventory/hosts -m shell -a "stat -c '%U:%G %a %n' /var/www/html/webapp" --become
```

4. Check Apache logs:

```bash
ansible web_servers -i inventory/hosts -m shell -a "tail -50 /var/log/httpd/error_log" --become
```

---

## 5) ❌ Load Balancer Play Fails: Backend Not Responding (HTTP checks)

### ✅ Symptoms

* Load balancer pre_task fails:

  * `Web server web1 is not responding`
* `uri` checks do not return status 200

### 🔍 Likely Causes

* Apache not started on backend
* Firewall missing `http` service rule on backend
* Backend reachable via IP but serving non-200 responses

### ✅ Fix

1. Confirm Apache running:

```bash
ansible web_servers -i inventory/hosts -m systemd -a "name=httpd" --become
```

2. Confirm firewall rules on web servers:

```bash
ansible web_servers -i inventory/hosts -m shell -a "firewall-cmd --list-all" --become
```

3. Test backend manually from controller:

```bash
curl -I http://web1/webapp/
curl -I http://web2/webapp/
```

---

## 6) ❌ HAProxy Config Invalid / Service Won’t Start

### ✅ Symptoms

* HAProxy fails to start
* `systemctl status haproxy` shows errors
* `haproxy -c -f /etc/haproxy/haproxy.cfg` fails

### 🔍 Likely Causes

* Template produced invalid config
* Backend server addresses are wrong
* Inventory hostnames don’t map to expected facts

### ✅ Fix

1. Validate HAProxy config:

```bash
ansible load_balancer -i inventory/hosts -m shell -a "haproxy -c -f /etc/haproxy/haproxy.cfg" --become
```

2. Inspect HAProxy config file:

```bash
ansible load_balancer -i inventory/hosts -m shell -a "sed -n '1,200p' /etc/haproxy/haproxy.cfg" --become
```

3. Restart service:

```bash
ansible load_balancer -i inventory/hosts -m systemd -a "name=haproxy state=restarted" --become
```

---

## 7) ❌ Firewall Blocking Traffic Between Tiers

### ✅ Symptoms

* DB reachable by SSH but app cannot connect
* web servers can’t reach DB port 3306
* LB can’t reach web servers on port 80

### 🔍 Likely Causes

* Missing `mysql` service rule on DB node
* Missing `http` service rule on web nodes
* Missing LB `80/tcp` rule on LB node
* Network security rules outside the OS firewall (cloud security group)

### ✅ Fix

1. List firewall rules:

```bash
ansible all -i inventory/hosts -m shell -a "firewall-cmd --list-all" --become
```

2. Ensure services/ports are enabled (examples):

```bash
ansible database_servers -i inventory/hosts -m firewalld -a "service=mysql permanent=yes state=enabled immediate=yes" --become
ansible web_servers -i inventory/hosts -m firewalld -a "service=http permanent=yes state=enabled immediate=yes" --become
ansible load_balancer -i inventory/hosts -m firewalld -a "port=80/tcp permanent=yes state=enabled immediate=yes" --become
```

---

## 8) ❌ Facts Missing / `ansible_date_time` undefined

### ✅ Symptoms

* Error: `ansible_date_time is undefined`
* Deployment ID/timestamp cannot be generated

### 🔍 Likely Causes

* `gather_facts: false` on localhost
* Facts gathering disabled globally

### ✅ Fix

* Ensure master play has:

```yaml
hosts: localhost
gather_facts: true
```

---

## 9) Debugging Checklist (Fast)

### ✅ Connectivity

```bash
ansible all -i inventory/hosts -m ping
```

### ✅ Facts

```bash
ansible all -i inventory/hosts -m setup
```

### ✅ Verbose Playbook Run

```bash
ansible-playbook -i inventory/hosts playbooks/site.yml -vvv
```

### ✅ Service Status

```bash
ansible all -i inventory/hosts -m shell -a "systemctl status httpd mariadb haproxy" --become
```

---

## 10) Rollback Procedure (When Needed)

### ✅ When to rollback

* Incomplete deployment leaves system inconsistent
* Critical configuration error breaks stack
* Need to reset environment quickly for re-run

### ✅ Rollback command

```bash
ansible-playbook -i inventory/hosts playbooks/rollback.yml
```

### ✅ After rollback

* Re-run dependency checks
* Run stack deployment again in phases:

```bash
ansible-playbook -i inventory/hosts playbooks/site.yml --tags database
ansible-playbook -i inventory/hosts playbooks/site.yml --tags webservers
ansible-playbook -i inventory/hosts playbooks/site.yml --tags loadbalancer
ansible-playbook -i inventory/hosts playbooks/site.yml --tags monitoring
```
