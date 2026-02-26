# 🛠️ Troubleshooting Guide — Lab 02: Understanding Playbooks

> This document lists common issues and fixes when creating inventories, writing playbooks, using templates, handling YAML formatting, and executing playbooks against managed nodes.

---

## 1) ❌ YAML parsing error (indentation / invalid YAML)
### ✅ Symptom
Running a playbook results in errors like:
- `ERROR! YAML syntax error while loading...`
- `mapping values are not allowed...`
- `did not find expected '-' indicator`

### 🧩 Cause
- YAML indentation is incorrect
- Invalid list markers were used (e.g., `•` instead of `-`)
- Mixed tabs/spaces
- Keys and values are misaligned

### ✅ Fix
- Use spaces only (2 spaces is common)
- Lists must use `-`
- Validate with syntax check before running:
```bash id="d1lo6r"
ansible-playbook -i inventory.ini install-package.yml --syntax-check
````

---

## 2) ❌ Inventory group not found / “No hosts matched”

### ✅ Symptom

Running:

```bash id="s5xehv"
ansible -i inventory.ini managed_nodes -m ping
```

returns:

```text id="ceghpp"
[WARNING]: Could not match supplied host pattern, ignoring: managed_nodes
ERROR! Specified hosts and/or --limit does not match any hosts
```

### 🧩 Cause

* Group name in playbook doesn’t match inventory
* Inventory file path not passed correctly

### ✅ Fix

Confirm inventory contents:

```bash id="xgc3rz"
cat inventory.ini
```

List inventory structure:

```bash id="pyq0aw"
ansible-inventory -i inventory.ini --list
```

Ensure playbook uses the correct group:

```yaml id="qg4xq6"
hosts: managed_nodes
```

---

## 3) ❌ SSH connectivity failures to managed nodes

### ✅ Symptom

* ping fails
* unreachable hosts
* authentication failures

Example:

```text id="dazv7t"
UNREACHABLE! => Failed to connect to the host via ssh: Permission denied (publickey)
```

### 🧩 Cause

* Wrong `ansible_user`
* Wrong SSH key path
* SSH key permissions incorrect
* Strict host key checking blocking connections

### ✅ Fix

Confirm inventory SSH variables:

```ini id="ntq6vr"
[all:vars]
ansible_ssh_private_key_file=/home/ansible/.ssh/id_rsa
ansible_ssh_common_args='-o StrictHostKeyChecking=no'
```

Check SSH key permissions:

```bash id="7u3p6n"
chmod 600 /home/ansible/.ssh/id_rsa
```

Test connectivity with ping:

```bash id="p0s2qv"
ansible -i inventory.ini managed_nodes -m ping
```

---

## 4) ❌ `firewalld` module fails (service not installed / not running)

### ✅ Symptom

Playbook fails on firewall task:

```yaml
firewalld:
  service: http
```

### 🧩 Cause

* `firewalld` package not installed
* `firewalld` service not started
* firewall daemon not available on target OS/image

### ✅ Fix

Install and start firewalld before enabling rules:

```yaml id="mh52a6"
- name: Install firewalld
  yum:
    name: firewalld
    state: present

- name: Start firewalld
  service:
    name: firewalld
    state: started
    enabled: yes
```

---

## 5) ❌ Template task fails (missing template file)

### ✅ Symptom

Playbook fails with:

```text id="6t3rp3"
Could not find or access 'index.html.j2'
```

### 🧩 Cause

* Template file not created
* Wrong relative path
* File not inside `templates/`

### ✅ Fix

Ensure structure:

```text id="0tsfyu"
templates/index.html.j2
```

Verify:

```bash id="3gn8u8"
ls -la templates/
```

Run playbook again.

---

## 6) ❌ Web verification fails (HTTP not responding)

### ✅ Symptom

`uri` module or curl check fails, status not 200.

### 🧩 Cause

* httpd not started
* firewall not configured (port 80 blocked)
* wrong URL used
* service using different document root

### ✅ Fix

Check service state:

```bash id="xj4l6s"
ansible -i inventory.ini managed_nodes -m service -a "name=httpd state=started" --become
```

Run a curl check locally on each node:

```bash id="kqjyoa"
ansible -i inventory.ini managed_nodes -m shell -a "curl -s -o /dev/null -w '%{http_code}\n' http://localhost"
```

If firewall is blocking, ensure rule:

```yaml id="hff16c"
- name: Configure firewall for web traffic
  firewalld:
    service: http
    permanent: yes
    state: enabled
    immediate: yes
```

---

## 7) ❌ Using `{{ }}` directly in shell commands doesn’t work

### ✅ Symptom

A command like this fails when typed in the shell:

```bash
curl http://{{ ansible_default_ipv4.address }}
```

### 🧩 Cause

Jinja2 variables only render inside playbooks/templates, not in normal Linux shell.

### ✅ Fix

Use Ansible modules or `shell` module to run commands properly:

```bash id="tfi44p"
ansible -i inventory.ini managed_nodes -m shell -a "curl -s -o /dev/null -w '%{http_code}\n' http://localhost"
```

Or use `uri` inside a playbook.

---

## 8) ✅ Best practice troubleshooting command: `-vvv`

### ✅ When to use

When debugging:

* SSH issues
* variable rendering
* module failures
* task execution logic

### ✅ Command

```bash id="ko9u6x"
ansible-playbook -i inventory.ini enhanced-playbook.yml -vvv
```
