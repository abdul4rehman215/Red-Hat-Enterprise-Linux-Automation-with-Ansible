# 🧪 Lab 10: Managing Files with Ansible (Copy + Template + Variables)

## 📌 Lab Summary
This lab focused on **file management in Ansible**, covering both:

- **Static file deployment** using the `copy` module (files + inline content)
- **Dynamic file generation** using the `template` module with **Jinja2 templates**
- Variable-driven customization using:
  - `group_vars/`
  - `host_vars/`
  - Ansible facts (`ansible_*`)

The lab also demonstrated validation (`httpd -t -f %s`), backups (`backup: yes`), ownership/permissions, and troubleshooting real-world issues like:
- missing directories in a fresh environment
- filesystem restrictions (e.g., `chattr +i` failing)
- missing packages (`ansible-lint` not available in repo)

---

## 🎯 Objectives
By the end of this lab, I was able to:

- Explain static vs dynamic file management in Ansible
- Use `copy` to deploy static configs, inline HTML, and small binary placeholders
- Use `template` to deploy dynamic configuration and HTML content using Jinja2
- Customize output per-host with `group_vars` and `host_vars`
- Apply ownership and permissions during deployment
- Use `validate` to ensure Apache config files are syntactically correct before applying
- Troubleshoot common issues with templates, file permissions, backups, and tool availability

---

## ✅ Prerequisites
- Linux filesystem and permissions basics
- YAML fundamentals
- Previous Ansible playbook + inventory experience
- Basic knowledge of variables in Ansible
- Comfort using editors like `nano`

---

## 🖥️ Lab Environment
- **Platform:** Cloud lab environment (pre-configured)
- **Control Node:** CentOS/RHEL 8 with Ansible installed
- **Managed Hosts:** 2 servers (`web1`, `web2`)
- **SSH:** Key-based connectivity configured

---

## 🗂️ Repository Structure
```text
lab10-managing-files-with-ansible/
├── README.md
├── commands.sh
├── output.txt
├── interview_qna.md
├── troubleshooting.md
├── inventory.ini
├── copy-static-files.yml
├── deploy-templates.yml
├── advanced-file-management.yml
├── test-file-management.yml
├── static-files/
│   ├── apache-security.conf
│   └── favicon.ico
├── templates/
│   ├── vhost.conf.j2
│   ├── system-info.conf.j2
│   ├── index.html.j2
│   └── conditional-template.j2
├── group_vars/
│   └── webservers.yml
└── host_vars/
    ├── web1.yml
    └── web2.yml
````

---

## ✅ Tasks Overview (What I Did)

### 📦 Task 1: Static File Deployment with `copy`

* Created a project workspace under `/home/student/ansible-labs/`
* Built a static Apache security configuration file:

  * hides Apache version information
  * blocks `.ht*` access
  * disables server-status/server-info locations
* Created a playbook to:

  * create backup directory
  * deploy security config with Apache validation
  * deploy a static HTML page (inline content)
  * deploy a placeholder favicon file
  * restart Apache if config changes

**Verification:**

* Confirmed files existed on managed hosts and had correct permissions/ownership.

---

### 🧩 Task 2: Dynamic Deployment with `template` (Jinja2)

* Created Jinja2 templates for:

  * Apache virtual host configs (`vhost.conf.j2`)
  * system info config (`system-info.conf.j2`)
  * dynamic HTML (`index.html.j2`)
* Implemented variables:

  * `group_vars/webservers.yml` for shared behavior (features, ports, environment, etc.)
  * `host_vars/web1.yml` and `host_vars/web2.yml` for host-specific server name, aliases, document roots, and max connections
* Wrote `deploy-templates.yml` to:

  * create backup directories
  * ensure host-specific document roots exist
  * deploy vhost + system info config + dynamic HTML
  * restart/reload Apache when vhost changes

**Verification:**

* Checked generated files under `/etc/httpd/conf.d/`
* Verified `/etc/system-info.conf` content rendered correctly using facts and variables
* Confirmed vhost files contained correct aliases and per-host settings

---

### 🧰 Task 3: Advanced File Management + Testing

* Created `advanced-file-management.yml` combining:

  * directory creation
  * static file copy with validation
  * template deployments into `/opt/app/config/`
  * dynamic summary file via copy content block
  * file attribute changes with `attributes: +i` (immutable bit)

**Notable behavior:**

* `chattr +i` failed due to filesystem restrictions (common in some VM/overlay environments)

* Remaining tasks succeeded and the handler archived configs to `/backup/`

* Created `test-file-management.yml` to validate multiple scenarios:

  * `get_url` download attempt
  * conditional template rendering
  * bulk file generation using loops
  * file discovery with `find`

**Verification:**

* Confirmed `/opt/app/` file layout + rendered templates
* Confirmed `/tmp` test files created

---

## ✅ Result

✅ Successfully automated both static and dynamic file deployment for Apache and application configuration:

* Static config deployment and validation works via `copy`
* Dynamic host-specific configs generated using Jinja2 templates
* Host/group variables and Ansible facts used to customize output
* Testing and verification playbooks confirm expected outputs
* Advanced automation includes backups and structured application directories

---

## 🌍 Why This Matters

File management is a core component of configuration management in real environments:

* Deploying repeatable and consistent configs across fleets
* Generating environment-specific configs (prod/stage/dev) automatically
* Enforcing correct permissions/ownership
* Reducing manual changes and configuration drift
* Building reliable automated deployments with validation and backups

---

## 🧠 What I Learned

* When to use `copy` vs `template`
* How to structure template variables using `group_vars` and `host_vars`
* How to safely deploy configs using `backup` + `validate`
* How to verify deployments using ad-hoc Ansible commands
* Real-world edge cases (missing directories, filesystem restrictions, missing packages)

---

## ✅ Conclusion

This lab built a strong foundation for managing both static and dynamic configuration files using Ansible. The skills practiced here directly apply to enterprise automation for web servers, app configurations, and scalable infrastructure deployments.

✅ Lab completed successfully.
