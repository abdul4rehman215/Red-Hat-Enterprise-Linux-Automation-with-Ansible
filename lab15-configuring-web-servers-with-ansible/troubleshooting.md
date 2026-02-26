# 🛠️ troubleshooting Guide — Lab 15: Configuring Web Servers with Ansible (Apache)

> This file captures common issues and fixes encountered while automating Apache web server deployments using Ansible.

---

## 🧩 Issue 1: SSH Connection Problems

### ❗ Problem
Ansible fails to connect:
- `UNREACHABLE!`
- `Permission denied (publickey)`
- host key mismatch prompts

### ✅ Cause
- wrong SSH username in inventory
- key not loaded/available
- strict host key checking blocks automation (lab environments often rotate hosts)

### ✅ Fix (Manual SSH Test)
```bash
ssh -i ~/.ssh/id_rsa ec2-user@192.168.1.10
````

### ✅ Fix (SSH Agent)

Check agent identities:

```bash
ssh-add -l
```

If no identities, add key:

```bash
ssh-add ~/.ssh/id_rsa
```

### ✅ Verification

Run Ansible ping:

```bash
ansible -i inventory/hosts.ini webservers -m ping
```

---

## 🧩 Issue 2: Permission Denied / Sudo Errors

### ❗ Problem

Tasks fail due to privilege errors:

* `permission denied`
* `sudo: a password is required`

### ✅ Cause

* missing `become: yes` or `ansible_become=yes`
* incorrect sudo access for the SSH user

### ✅ Fix (Validate sudo)

```bash
ansible -i inventory/hosts.ini webservers -m shell -a "sudo whoami"
```

### 📌 Output (example)

```text
web1 | CHANGED | rc=0 >>
root
web2 | CHANGED | rc=0 >>
root
```

### ✅ Verify inventory user configuration

```bash
cat inventory/hosts.ini
```

---

## 🧩 Issue 3: Firewall Blocking HTTP Access

### ❗ Problem

Apache is running but HTTP is not accessible:

* browser timeout
* curl fails
* `uri` module fails

### ✅ Cause

Port 80 is blocked by firewalld zone configuration.

### ✅ Fix (Inspect firewall rules)

```bash
ansible -i inventory/hosts.ini webservers -m shell -a "firewall-cmd --list-all" --become
```

### ✅ Fix (Open HTTP service)

```bash
ansible -i inventory/hosts.ini webservers -m firewalld -a "service=http permanent=yes state=enabled immediate=yes" --become
```

### 📌 Output (example)

```text
web1 | SUCCESS => {"changed": false, "immediate": true, "permanent": true, "service": "http", "state": "enabled"}
web2 | SUCCESS => {"changed": false, "immediate": true, "permanent": true, "service": "http", "state": "enabled"}
```

---

## 🧩 Issue 4: Apache Configuration Errors

### ❗ Problem

Apache fails to start or restarts repeatedly:

* systemd shows failed state
* HTTP returns 503/connection refused
* playbook fails at service start/restart step

### ✅ Cause

Misconfigured `/etc/httpd/conf/httpd.conf` or conflicting directives.

### ✅ Fix (Syntax test)

```bash
ansible -i inventory/hosts.ini webservers -m shell -a "httpd -t" --become
```

### 📌 Output (example)

```text
web1 | CHANGED | rc=0 >>
Syntax OK
web2 | CHANGED | rc=0 >>
Syntax OK
```

### ✅ Fix (Check error logs)

```bash
ansible -i inventory/hosts.ini webservers -m shell -a "tail -20 /var/log/httpd/error_log" --become
```

---

## 🧩 Issue 5: Port 80 Not Listening

### ❗ Problem

Service shows active, but port is not reachable.

### ✅ Cause

* httpd not bound properly
* firewall rules missing
* service actually not listening due to config reload failures

### ✅ Fix (Verify port listening)

`netstat` may be missing on minimal images:

```bash
ansible -i inventory/hosts.ini webservers -m shell -a "netstat -tlnp | grep :80"
```

If missing:

```bash
ansible -i inventory/hosts.ini webservers -m yum -a "name=net-tools state=present" --become
```

Then retry:

```bash
ansible -i inventory/hosts.ini webservers -m shell -a "netstat -tlnp | grep :80"
```

### 📌 Output (example)

```text
tcp6       0      0 :::80                   :::*                    LISTEN      2157/httpd
```

---

## 🧩 Issue 6: URI Verification Mistakes (Wrong Target Host)

### ❗ Problem

One host shows `404 Not Found` during verification even though deployment succeeded.

### ✅ Cause

The request was made to the wrong IP for a host (example: querying `192.168.1.10` for both web1 and web2).

### ✅ Fix

Use each host’s actual IP:

```bash
ansible -i inventory/hosts.ini webservers -m uri -a "url=http://{{ ansible_host }} method=GET"
```

---

## ✅ Quick Validation Checklist (Post-Deployment)

```bash
ansible -i inventory/hosts.ini webservers -m systemd -a "name=httpd" --become
ansible -i inventory/hosts.ini webservers -m uri -a "url=http://{{ ansible_host }} method=GET"
ansible -i inventory/hosts.ini webservers -m shell -a "firewall-cmd --list-all" --become
ansible -i inventory/hosts.ini webservers -m shell -a "httpd -t" --become
```
