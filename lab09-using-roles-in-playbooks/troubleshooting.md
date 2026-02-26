# 🛠️ Lab 09: Using Roles in Playbooks — Troubleshooting Guide

> This guide covers common issues when creating and running **role-based Ansible deployments** for Apache HTTP Server.

---

## 1) ❌ “Role not found” error

### ✅ Symptoms
- Playbook fails immediately with a message like:
  - `ERROR! the role 'apache-webserver' was not found`

### 🔍 Likely Causes
- Role directory name mismatch (playbook role name ≠ folder name)
- Role is not under the expected `roles/` directory
- Running playbook from the wrong working directory

### ✅ Fix / Validation Steps
1. Confirm role exists and name matches:
```bash
ls -la roles/
ls -la roles/apache-webserver/
````

2. Ensure you are running playbooks from the project root where `roles/` exists:

```bash
pwd
tree roles/
```

3. Ensure playbook role reference matches directory exactly:

```yaml
roles:
  - apache-webserver
```

---

## 2) ❌ Firewall task fails: “Failed to connect to bus: No such file or directory”

### ✅ Symptoms

* Task output similar to:

  * `Failed to connect to bus: No such file or directory`
* Task is marked failed but play continues if `ignore_errors: yes`

### 🔍 Likely Causes

* Firewalld requires DBus/systemd interaction, and the environment may not have it available
* Firewalld service not installed or not running
* Minimal container-like lab nodes or restricted system services

### ✅ Fix / Validation Steps

1. Check if firewalld is running:

```bash
ansible web_servers -i inventory.ini -m shell -a "systemctl status firewalld" --become
```

2. Start and enable firewalld if needed (lab environment permitting):

```bash
ansible web_servers -i inventory.ini -m systemd -a "name=firewalld state=started enabled=yes" --become
```

3. If firewalld is not used in the environment, keep the task non-blocking:

* `ignore_errors: yes` (already used in this lab)

---

## 3) ❌ Firewall task fails: “FirewallD is not running”

### ✅ Symptoms

* Task error:

  * `"msg": "FirewallD is not running"`
* Task continues due to ignore_errors but HTTP might be blocked depending on environment rules.

### 🔍 Likely Causes

* Firewalld service is stopped or not installed
* The lab image may use different firewall tooling or firewall disabled by design

### ✅ Fix / Validation Steps

1. Confirm firewalld status:

```bash
ansible web_servers -i inventory.ini -m systemd -a "name=firewalld" --become
```

2. Start firewalld:

```bash
ansible web_servers -i inventory.ini -m systemd -a "name=firewalld state=started enabled=yes" --become
```

3. If firewalld is unavailable, validate whether HTTP still works:

```bash
curl http://192.168.1.10
curl http://192.168.1.11
```

---

## 4) ❌ Web page not accessible after successful playbook

### ✅ Symptoms

* `curl http://<node-ip>` fails or times out
* Browser cannot load the page

### 🔍 Likely Causes

* Apache service not running
* Firewall blocks port 80
* Wrong IP used (inventory mismatch)
* Network/security group restrictions in lab environment

### ✅ Fix / Validation Steps

1. Verify Apache is running:

```bash
ansible web_servers -i inventory.ini -m service -a "name=httpd state=started" --become
```

2. Check port 80 listening:

```bash
ansible web_servers -i inventory.ini -m shell -a "ss -tlnp | grep :80" --become
```

3. Check firewall services:

```bash
ansible web_servers -i inventory.ini -m shell -a "firewall-cmd --list-services" --become
```

---

## 5) ❌ Apache config syntax errors (httpd won’t start)

### ✅ Symptoms

* Apache service fails to start
* `httpd -t` returns errors
* Web server returns 503 or connection refused

### 🔍 Likely Causes

* Broken template rendering in `vhost.conf.j2`
* Missing required module directives or headers module not loaded in minimal configs
* Invalid directive values due to undefined variables

### ✅ Fix / Validation Steps

1. Validate Apache configuration syntax:

```bash
ansible web_servers -i inventory.ini -m shell -a "httpd -t" --become
```

2. Inspect generated vhost config file:

```bash
ansible web_servers -i inventory.ini -m shell -a "cat /etc/httpd/conf.d/production-site.conf" --become
```

3. Confirm required variables are defined:

* `apache_port`
* `site_name`
* `server_name`
* `server_admin`
* `server_tokens`
* `server_signature`

---

## 6) ❌ Template rendering issues (undefined variables)

### ✅ Symptoms

* Ansible errors like:

  * `The task includes an option with an undefined variable`
* Template files fail to deploy

### 🔍 Likely Causes

* Variables referenced in templates not present in defaults/vars/playbook vars
* Typos in variable names
* Variable scope misunderstanding

### ✅ Fix / Validation Steps

1. Check variable definitions:

* `roles/apache-webserver/defaults/main.yml`
* `roles/apache-webserver/vars/main.yml`
* playbook `vars` in `deploy-webserver-advanced.yml`

2. Run syntax check:

```bash
ansible-playbook -i inventory.ini --syntax-check deploy-webserver.yml
```

---

## 7) ❌ Validation playbook fails at service_facts/assert

### ✅ Symptoms

* Assertion fails:

  * `Apache service is not running`

### 🔍 Likely Causes

* Apache service stopped unexpectedly
* Service name differs on other OS families (e.g., Debian uses `apache2`)
* System facts not updated if service isn’t installed

### ✅ Fix / Validation Steps

1. Confirm correct service name (RHEL/CentOS uses `httpd`):

```bash
ansible web_servers -i inventory.ini -m shell -a "systemctl status httpd" --become
```

2. Start service:

```bash
ansible web_servers -i inventory.ini -m service -a "name=httpd state=started enabled=yes" --become
```

---

## 8) ❌ Variable override not applied in advanced playbook

### ✅ Symptoms

* Web page shows old values (welcome message/company)
* Vhost config doesn’t reflect new performance settings

### 🔍 Likely Causes

* Variables defined in `vars/main.yml` (higher precedence) override defaults and can override some playbook values unless explicitly overridden properly
* Role-level var overrides not placed in correct scope

### ✅ Fix / Validation Steps

1. Ensure overrides exist under the correct sections in playbook:

```yaml
vars:
  welcome_message: "..."
  company_name: "..."
roles:
  - role: apache-webserver
    vars:
      max_connections: 200
      timeout: 600
```

2. Re-run the advanced playbook:

```bash
ansible-playbook -i inventory.ini deploy-webserver-advanced.yml
```

---

## ✅ Quick “Known Good” Checks (from this lab)

### Check Apache service and config syntax

```bash
ansible web_servers -i inventory.ini -m service -a "name=httpd state=started" --become
ansible web_servers -i inventory.ini -m shell -a "httpd -t" --become
```

### Verify web page loads

```bash
curl http://192.168.1.10
curl http://192.168.1.11
```

### Validate deployment assertions

```bash
ansible-playbook -i inventory.ini validate-deployment.yml
```

---
