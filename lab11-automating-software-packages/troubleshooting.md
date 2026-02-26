# 🛠️ Lab 11: Automating Software Packages — Troubleshooting Guide

> This guide covers common issues when automating software package management across mixed OS fleets (RHEL/CentOS + Ubuntu) using Ansible.

---

## 1) ❌ Hosts unreachable / ping fails

### ✅ Symptoms
- `ansible -m ping` shows:
  - `UNREACHABLE!`
  - SSH permission denied
  - timeouts

### 🔍 Likely Causes
- Wrong `ansible_user` in inventory
- Wrong or missing SSH key path
- Security group / firewall blocking SSH
- DNS/IP mismatch

### ✅ Fix / Resolution
1. Confirm inventory settings:
```ini
ansible_user=ansible
ansible_ssh_private_key_file=~/.ssh/id_rsa
````

2. Test connectivity:

```bash
ansible all -i inventory/hosts -m ping
```

3. If needed, verify SSH manually:

```bash
ssh -i ~/.ssh/id_rsa ansible@10.0.1.10
```

---

## 2) ❌ Package name differs between OS families

### ✅ Symptoms

* `No package matching ... is available`
* `Unable to locate package ...`
* Playbook works on one OS but fails on another

### 🔍 Likely Causes

* Same software uses different names:

  * `httpd` (RHEL) vs `apache2` (Debian)
  * `python3-PyMySQL` (RHEL) vs `python3-pymysql` (Debian)

### ✅ Fix / Resolution

Use OS-mapped variables and the `package` module:

```yaml
web_server_packages:
  RedHat: [httpd, mod_ssl]
  Debian: [apache2, ssl-cert]

- name: Install web server packages
  package:
    name: "{{ web_server_packages[ansible_os_family] }}"
    state: present
```

---

## 3) ❌ Package not found due to missing repositories (EPEL / Docker)

### ✅ Symptoms

* RHEL: packages like `htop`, `ncdu`, `iotop` fail
* Docker packages fail to install

### 🔍 Likely Causes

* EPEL not enabled
* Docker repo not added
* Repo metadata outdated or cached

### ✅ Fix / Resolution

**RHEL: enable EPEL**

```yaml
- name: Install EPEL repository
  yum:
    name: epel-release
    state: present
```

**RHEL: add Docker repo**

```yaml
- name: Add Docker repository
  yum_repository:
    name: docker-ce-stable
    baseurl: https://download.docker.com/linux/centos/8/$basearch/stable
    gpgcheck: yes
    gpgkey: https://download.docker.com/linux/centos/gpg
    enabled: yes
```

**Ubuntu: add Docker repo**

```yaml
- name: Add Docker GPG key
  apt_key:
    url: https://download.docker.com/linux/ubuntu/gpg
    state: present

- name: Add Docker repository
  apt_repository:
    repo: "deb [arch=amd64] https://download.docker.com/linux/ubuntu {{ ansible_distribution_release }} stable"
    state: present
    update_cache: yes
```

---

## 4) ❌ `yum update` or `apt update` fails (repo access / network)

### ✅ Symptoms

* metadata download failures
* DNS errors
* repository unreachable errors

### 🔍 Likely Causes

* network restrictions in lab environment
* DNS not configured
* repo endpoint blocked or temporarily down

### ✅ Fix / Resolution

1. Validate name resolution:

```bash
ansible all_servers -i inventory/hosts -m shell -a "getent hosts download.docker.com" --become
```

2. Retry with cache update:

* RHEL:

```yaml
yum:
  update_cache: yes
```

* Debian:

```yaml
apt:
  update_cache: yes
  cache_valid_time: 3600
```

3. Add `failed_when: false` for reporting-style tasks:

```yaml
failed_when: false
```

---

## 5) ❌ Services fail to start after package installation

### ✅ Symptoms

* Docker or web server installed but not running
* systemd task fails with “Unit not found” or “failed”

### 🔍 Likely Causes

* service name mismatch (`httpd` vs `apache2`)
* service not installed due to package failures
* daemon requires reboot or extra dependencies

### ✅ Fix / Resolution

Use OS-specific service start tasks:

```yaml
- name: Start web server (RHEL)
  systemd:
    name: httpd
    state: started
    enabled: yes
  when: ansible_os_family == "RedHat"

- name: Start web server (Debian)
  systemd:
    name: apache2
    state: started
    enabled: yes
  when: ansible_os_family == "Debian"
```

For Docker:

```yaml
- name: Start Docker
  systemd:
    name: docker
    state: started
    enabled: yes
```

---

## 6) ❌ Optional packages fail (but shouldn’t break deployment)

### ✅ Symptoms

* Example from this lab:

  * `"No package matching 'emacs' is available"`
* If not handled, playbook would fail

### 🔍 Likely Causes

* Package not present in repos
* Different package naming between repos/OS versions
* Minimal lab repo set

### ✅ Fix / Resolution

Use `block/rescue` to log and continue:

```yaml
- name: Install optional packages
  block:
    - name: Install optional (RHEL)
      yum:
        name: "{{ optional_packages }}"
        state: present
      when: ansible_os_family == "RedHat"
  rescue:
    - name: Log warning
      lineinfile:
        path: /tmp/package_backup/installation_warnings.log
        line: "Optional package install failed on {{ inventory_hostname }}"
        create: yes
    - name: Continue
      debug:
        msg: "Optional packages failed, continuing..."
```

---

## 7) ❌ Universal playbook monitoring packages fail on Ubuntu

### ✅ Symptoms

* Example from this lab:

  * `No package matching 'nagios-nrpe-server' is available`

### 🔍 Likely Causes

* Package not present in configured repos
* Repo not enabled (universe/multiverse) or package renamed

### ✅ Fix / Resolution

Treat monitoring as optional:

```yaml
- name: Install monitoring packages
  package:
    name: "{{ monitoring_packages[ansible_os_family] }}"
    state: present
  ignore_errors: yes
```

---

## 8) ❌ URI checks fail even though Apache is installed

### ✅ Symptoms

* `uri` returns non-200 or connection error

### 🔍 Likely Causes

* service not running
* firewall blocked
* index.html not placed correctly
* networking restrictions

### ✅ Fix / Resolution

1. Confirm service is active:

```bash
ansible all_servers -i inventory/hosts -m shell -a "systemctl status httpd || systemctl status apache2" --become
```

2. Check listening port:

```bash
ansible all_servers -i inventory/hosts -m shell -a "ss -tlnp | egrep ':80|:443'" --become
```

3. Ensure index.html exists:

```bash
ansible all_servers -i inventory/hosts -m shell -a "ls -la /var/www/html/index.html" --become
```

---

## 9) ❌ Report generation issues (files not created where expected)

### ✅ Symptoms

* `/tmp/ansible_reports/` missing
* reports empty or incomplete

### 🔍 Likely Causes

* report directory task didn’t run on localhost properly
* insufficient permissions
* incorrect delegate usage

### ✅ Fix / Resolution

Ensure the report directory is created on localhost:

```yaml
- name: Create report directory
  file:
    path: "{{ report_dir }}"
    state: directory
    mode: "0755"
  delegate_to: localhost
  run_once: true
```

Then verify:

```bash
ls -la /tmp/ansible_reports/
cat /tmp/ansible_reports/*_package_report.txt
```

---

## ✅ Quick “Known Good” Validation Commands (from this lab)

### Connectivity

```bash
ansible all -i inventory/hosts -m ping
```

### Validate packages installed

```bash
ansible all -i inventory/hosts -m command -a "which git" --become
ansible all -i inventory/hosts -m command -a "python3 --version" --become
```

### Verify Docker installed

```bash
ansible all -i inventory/hosts -m command -a "docker --version" --become
```

### Verify reports exist

```bash
ls -la /tmp/ansible_reports/
cat /tmp/ansible_reports/*_package_report.txt
```

---
