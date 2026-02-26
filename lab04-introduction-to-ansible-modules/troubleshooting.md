# 🛠️ Troubleshooting Guide — Lab 04: Introduction to Ansible Modules

> This document covers common issues encountered when using Ansible modules (`yum`, `apt`, `package`, `service`, `uri`) across different Linux distributions.

---

## 1) ❌ Module not found / unsure how to use a module
### ✅ Symptom
You don’t know module options or get unexpected behavior.

### 🧩 Cause
Using a module without checking correct parameters/options.

### ✅ Fix
Use Ansible module documentation:
```bash id="lq1m4v"
ansible-doc yum
ansible-doc apt
ansible-doc service
ansible-doc package
ansible-doc uri
````

List installed modules:

```bash id="d1b3r8"
ansible-doc -l | head -20
```

---

## 2) ❌ Connectivity issues (`ping` fails / UNREACHABLE)

### ✅ Symptom

Running:

```bash id="s2n8w9"
ansible all -m ping
```

returns unreachable/SSH failures.

### 🧩 Cause

* Inventory incorrect
* SSH key issues
* Wrong user defined in inventory
* Host key checking blocking connections

### ✅ Fix

Verify inventory:

```bash id="zx6w2n"
cat /etc/ansible/hosts
```

Test with verbose output:

```bash id="m8x3p0"
ansible all -m ping -vvv
```

If host key checking causes issues, confirm:

```ini id="d5f0c1"
[all:vars]
ansible_ssh_common_args='-o StrictHostKeyChecking=no'
```

---

## 3) ❌ Package install fails due to permissions

### ✅ Symptom

Playbook fails on package tasks with permission errors.

### 🧩 Cause

Package installs require root privileges.

### ✅ Fix

Ensure playbook includes:

```yaml id="s9m3q5"
become: yes
```

Or run ad-hoc with become:

```bash id="x0t9b2"
ansible all -m package -a "name=git state=present" --become
```

---

## 4) ❌ Using the wrong package module for OS (yum on Ubuntu / apt on CentOS)

### ✅ Symptom

Tasks fail because `yum` doesn’t exist on Ubuntu or `apt` doesn’t exist on RHEL.

### 🧩 Cause

Using OS-specific modules on the wrong OS family.

### ✅ Fix

Use conditions:

```yaml id="q1p0w8"
when: ansible_os_family == "RedHat"
```

```yaml id="o8r2x7"
when: ansible_os_family == "Debian"
```

Or use cross-platform `package` module when possible:

```yaml id="g2v1q9"
- name: Install a package in a portable way
  package:
    name: git
    state: present
```

---

## 5) ❌ Service verification fails due to service name differences

### ✅ Symptom

Checking `httpd` on Ubuntu fails:

```text id="c8n2p1"
Could not find the requested service httpd: host
```

Or checking `apache2` on CentOS fails:

```text id="t4h9m3"
Could not find the requested service apache2: host
```

### 🧩 Cause

Service names differ by distro:

* RHEL/CentOS → `httpd`
* Ubuntu/Debian → `apache2`

### ✅ Fix

Use OS-aware service name:

```yaml id="f2v0m8"
name: "{{ 'httpd' if ansible_os_family == 'RedHat' else 'apache2' }}"
```

---

## 6) ❌ Firewall module/service mismatch (`firewalld` vs `ufw`)

### ✅ Symptom

Firewall service tasks fail on the wrong OS.

### 🧩 Cause

* `firewalld` is typical for RHEL family
* `ufw` is typical for Debian family

### ✅ Fix

Use conditionals:

```yaml id="g0c5n9"
when: ansible_os_family == "RedHat"
```

and

```yaml id="m9w3y1"
when: ansible_os_family == "Debian"
```

---

## 7) ❌ Web server not responding (HTTP test fails)

### ✅ Symptom

`uri` module returns non-200 status or failure.

### 🧩 Cause

* web server not started
* firewall blocking port 80
* wrong document root / missing index file

### ✅ Fix

Check service state:

```bash id="k9m2r8"
ansible all -m service -a "name=httpd state=started" --become
ansible all -m service -a "name=apache2 state=started" --become
```

Verify HTTP from each node:

```bash id="r2n8w0"
ansible all -m uri -a "url=http://localhost method=GET status_code=200"
```

---

## 8) ❌ Playbook stops due to expected failures (testing error handling)

### ✅ Symptom

Playbook fails when testing a non-existent package/service.

### 🧩 Cause

Ansible stops on task failures unless told otherwise.

### ✅ Fix

For testing scenarios:

* `ignore_errors: yes` for non-critical tasks
* `failed_when: false` for modules where failure is expected
* handle results using `register` + `when`

Example:

```yaml id="b2r7q1"
- name: Try to start a service with error handling
  service:
    name: non-existent-service
    state: started
  register: service_result
  failed_when: false
```

---

## 9) ✅ Best practice: syntax check before running

### ✅ Command

```bash id="x1v8m2"
ansible-playbook --syntax-check infrastructure-setup.yml
```

This helps catch YAML and formatting errors before execution.

---
