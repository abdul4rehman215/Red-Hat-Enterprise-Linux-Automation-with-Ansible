# 🛠️ Lab 10: Managing Files with Ansible — Troubleshooting Guide

> This guide covers common issues when managing files using Ansible `copy` and `template` modules, especially when deploying Apache configs, dynamic templates, and advanced file operations.

---

## 1) ❌ “No such file or directory” when changing into the working directory

### ✅ Symptoms
- `cd /home/student/ansible-labs` fails:
  - `bash: cd: /home/student/ansible-labs: No such file or directory`

### 🔍 Likely Causes
- Fresh lab environment did not include the directory structure

### ✅ Fix / Resolution
Create the directory and ensure correct ownership:
```bash
sudo mkdir -p /home/student/ansible-labs
sudo chown -R $(whoami):$(whoami) /home/student
cd /home/student/ansible-labs
````

---

## 2) ❌ Copy task fails because source directory does not exist

### ✅ Symptoms

* Creating a file directly under a missing folder causes an editor error
* `copy` fails because source file isn’t found

### 🔍 Likely Causes

* Folder was not created before writing the file

### ✅ Fix / Resolution

Create the folder before writing files:

```bash
mkdir -p static-files
nano static-files/apache-security.conf
```

---

## 3) ❌ Apache configuration deployment breaks Apache service

### ✅ Symptoms

* Apache restart handler fails
* Web server becomes inaccessible after config deployment

### 🔍 Likely Causes

* Invalid Apache configuration file pushed to `/etc/httpd/conf.d/`
* Template generated incorrect syntax
* Missing variables produced empty directives

### ✅ Fix / Resolution

Use `validate` to prevent bad configs from being applied:

```yaml
validate: "httpd -t -f %s"
```

You can also validate manually:

```bash
ansible webservers -i inventory.ini -m shell -a "httpd -t" --become
```

---

## 4) ❌ Template rendering fails due to Jinja2 syntax errors

### ✅ Symptoms

* Playbook fails with Jinja2 exceptions
* “unexpected end of template” or invalid syntax messages

### 🔍 Likely Causes

* Missing `{% endif %}` or `{% endfor %}`
* Incorrect indentation in YAML when embedding templates
* Variable reference typos

### ✅ Fix / Resolution

1. Run Ansible syntax check:

```bash
ansible-playbook --syntax-check deploy-templates.yml
```

2. Validate template logic:

* ensure every `{% if %}` has an `{% endif %}`
* ensure every `{% for %}` has an `{% endfor %}`

---

## 5) ❌ Undefined variables in templates

### ✅ Symptoms

* Errors like:

  * `The task includes an option with an undefined variable`

### 🔍 Likely Causes

* Variables not set in:

  * `group_vars/`
  * `host_vars/`
  * playbook `vars`
* Template expects a variable that isn’t defined for all hosts

### ✅ Fix / Resolution

Use safe defaults and checks:

```jinja2
{{ variable_name | default('default_value') }}
```

```jinja2
{% if variable_name is defined %}
{{ variable_name }}
{% else %}
Default Value
{% endif %}
```

---

## 6) ❌ `ansible-lint` not found or cannot be installed

### ✅ Symptoms

* `ansible-lint: command not found`
* `yum install ansible-lint` fails:

  * `No match for argument: ansible-lint`

### 🔍 Likely Causes

* Minimal lab image
* Repository configuration does not include ansible-lint package

### ✅ Fix / Resolution

Use built-in checks instead:

```bash
ansible-playbook --syntax-check deploy-templates.yml
```

In real environments you can install using:

* OS repositories (if available)
* pip install (if policy allows)
* curated internal repositories

---

## 7) ❌ Firewall or module-related issues when deploying Apache configs

### ✅ Symptoms

* Apache is configured but HTTP not reachable

### 🔍 Likely Causes

* firewall blocks port 80
* service not started
* network restrictions outside of host

### ✅ Fix / Resolution

1. Ensure Apache is running:

```bash
ansible webservers -i inventory.ini -m service -a "name=httpd state=started enabled=yes" --become
```

2. Check listening ports:

```bash
ansible webservers -i inventory.ini -m shell -a "ss -tlnp | grep :80" --become
```

3. If firewalld is used:

```bash
ansible webservers -i inventory.ini -m firewalld -a "service=http permanent=yes state=enabled immediate=yes" --become
```

---

## 8) ❌ Advanced playbook fails at `chattr +i` (immutable bit)

### ✅ Symptoms

* Task fails:

  * `chattr: Operation not permitted while setting flags on /opt/app/config`

### 🔍 Likely Causes

* Filesystem does not support immutable flags
* OverlayFS / container-like or restricted virtualization environment
* Security policy restrictions (common in labs)

### ✅ Fix / Resolution

Option A (recommended): remove immutable attribute logic for this environment:

```yaml
attributes: "+i"
```

→ remove or guard it conditionally.

Option B: ignore the error for portability:

```yaml
ignore_errors: yes
```

Option C: check filesystem type first and apply only when supported.

---

## 9) ❌ Too many backup files created by `backup: yes`

### ✅ Symptoms

* Config directories accumulate many `.bak` backup files
* Disk usage increases over time

### 🔍 Likely Causes

* Frequent runs of playbooks with backup enabled

### ✅ Fix / Resolution

Implement cleanup tasks:

```yaml
- name: Clean old backup files
  find:
    paths: /etc/httpd/conf.d
    patterns: "*.conf.*"
    age: "7d"
  register: old_backups

- name: Remove old backup files
  file:
    path: "{{ item.path }}"
    state: absent
  loop: "{{ old_backups.files }}"
```

---

## 10) ❌ Incorrect ownership/permissions after deployment

### ✅ Symptoms

* Web server can’t read files
* Permission denied errors

### 🔍 Likely Causes

* wrong owner/group (Apache expects `apache:apache` for web files)
* wrong file modes
* files placed in directories with restrictive permissions

### ✅ Fix / Resolution

Enforce correct permissions using `file` module:

```yaml
- name: Fix web content permissions
  file:
    path: "{{ item }}"
    owner: apache
    group: apache
    mode: "0644"
    recurse: yes
  loop:
    - /var/www/html
    - /opt/app/static
```

---

## ✅ Quick “Known Good” Verification Commands (from this lab)

### Verify static file deployment

```bash
ansible webservers -i inventory.ini -m shell -a "ls -la /etc/httpd/conf.d/security.conf"
ansible webservers -i inventory.ini -m shell -a "ls -la /var/www/html/"
```

### Verify template results

```bash
ansible webservers -i inventory.ini -m shell -a "ls -la /etc/httpd/conf.d/"
ansible webservers -i inventory.ini -m shell -a "head -20 /etc/system-info.conf"
ansible webservers -i inventory.ini -m shell -a "cat /etc/httpd/conf.d/web*.conf"
```

### Verify advanced output

```bash
ansible webservers -i inventory.ini -m shell -a "find /opt/app -type f -ls"
ansible webservers -i inventory.ini -m shell -a "cat /opt/app/config/system-info.conf"
```

### Verify testing artifacts

```bash
ansible webservers -i inventory.ini -m shell -a "ls -la /tmp/*.conf /tmp/*.txt 2>/dev/null"
```

---
