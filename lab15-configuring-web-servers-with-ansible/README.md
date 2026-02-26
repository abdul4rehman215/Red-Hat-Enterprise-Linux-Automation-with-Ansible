# 🌐 Lab 15: Configuring Web Servers with Ansible (Apache HTTP Server)

## 🧾 Lab Summary
In this lab, I used Ansible to automate **end-to-end web server provisioning** on CentOS/RHEL 8 managed nodes.  
The automation covered:

- Verifying Ansible installation and configuration on the control node
- Building a clean Ansible project structure (playbooks, inventory, templates, files)
- Creating an inventory group for web servers (`webservers`)
- Installing and configuring **Apache (httpd)**
- Managing services using `systemd` handlers and idempotent playbooks
- Opening HTTP access through **firewalld**
- Deploying a **dynamic HTML page** via Jinja2 template + static assets (CSS)
- Adding a full “master” playbook to combine setup + deployment + verification
- Creating a verification playbook and troubleshooting common issues

> Environment note: executed in a **guided cloud lab environment** using a CentOS/RHEL 8 control node and two CentOS/RHEL 8 managed nodes.

---

## 🎯 Objectives
By the end of this lab, I was able to:

- Understand fundamentals of Ansible automation for web server configuration
- Write and execute playbooks to install and configure Apache web server
- Ensure web services are enabled and running using Ansible
- Deploy custom HTML content to web servers using templates and files
- Implement infrastructure-as-code best practices (idempotency, tags, handlers)
- Troubleshoot common issues during Ansible playbook execution

---

## ✅ Prerequisites
- Basic Linux CLI knowledge
- Familiarity with YAML syntax
- Basic web server / HTTP understanding
- SSH key-based authentication knowledge
- Access to a text editor (nano/vim)

---

## 🧰 Lab Environment Setup
**Control Node**
- CentOS/RHEL 8 with Ansible pre-installed

**Managed Nodes**
- Two CentOS/RHEL 8 web servers:
  - `web1` (192.168.1.10)
  - `web2` (192.168.1.11)

**Access**
- SSH connectivity preconfigured
- Sudo privileges available

---

## 📁 Repository Structure (Lab Folder)

```text
lab15-configuring-web-servers-with-ansible/
├── README.md
├── commands.sh
├── output.txt
├── ansible-config.txt                    # captured output of `ansible-config view` (optional artifact)
├── inventory/
│   └── hosts.ini
├── playbooks/
│   ├── install-apache.yml
│   ├── deploy-website.yml
│   ├── complete-webserver-setup.yml
│   ├── deploy-content.yml
│   └── verify-deployment.yml
├── templates/
│   ├── index.html.j2
│   └── httpd.conf.j2
└── files/
    └── style.css
````

> Note: `ansible-config.txt` is optional, but I kept it as a useful artifact to show baseline config captured from the control node.

---

## 🧩 Tasks Overview

### ✅ Task 1: Inventory + Project Setup

* Verified Ansible installation and reviewed Ansible configuration
* Built a clean project folder structure:

  * `playbooks/`, `inventory/`, `templates/`, `files/`
* Created `inventory/hosts.ini` defining `web1` and `web2`
* Tested connectivity using Ansible ping module (group and all-host tests)

### ✅ Task 2: Install and Configure Apache

* Wrote an Apache installation playbook using `yum`
* Added configuration tasks to write `/etc/httpd/conf/httpd.conf`
* Ensured document root permissions (`/var/www/html`)
* Opened HTTP through firewalld (`service=http`)
* Implemented handlers (`restart apache`, `reload apache`)

### ✅ Task 3: Ensure Services are Enabled and Verified

* Started and enabled Apache service using `systemd`
* Verified Apache service state (`ActiveState`)
* Verified port 80 is listening using `wait_for`

### ✅ Task 4: Deploy Web Content

* Created a dynamic Jinja2 template (`index.html.j2`)
* Created a static CSS file (`style.css`)
* Built `deploy-website.yml` playbook to deploy:

  * `index.html` (template)
  * `style.css` (copy)
  * `about.html` (inline copy content)
* Verified content is accessible via HTTP (status 200)

### ✅ Task 5: Master Playbook + Include Tasks

* Built `complete-webserver-setup.yml` to run full setup:

  * Install dependencies
  * Configure Apache from template
  * Enable services
  * Configure firewall
  * Include content deployment via `deploy-content.yml`
  * Verify service + HTTP response
  * Print deployment summary (status + URL)
* Demonstrated idempotency (second run shows changed=0)

### ✅ Task 6: Verification Playbook + Manual Validation

* Built `verify-deployment.yml`:

  * validates port 80
  * validates main page, about page, and CSS all return HTTP 200
* Verified using:

  * `uri` module
  * `systemd` status
  * `netstat` (install net-tools if missing)
  * `curl` from control node

---

## ✅ Verification & Validation

Evidence collected in this lab includes:

* `ansible -m ping` success to all hosts
* Ansible playbook runs with:

  * `failed=0`
  * repeat runs show idempotency (`changed=0` where expected)
* `uri` module checks return `status: 200`
* Apache service status: `Active: active (running)`
* Port listening checks pass:

  * `wait_for port=80`
  * `netstat -tlnp | grep :80`
* `curl http://<ip>` returns dynamic HTML page per host

---

## 🧾 Result

* ✅ Apache installed and configured on `web1` and `web2`
* ✅ Firewall opened for HTTP
* ✅ Website content deployed:

  * `/index.html`
  * `/about.html`
  * `/style.css`
* ✅ Verification playbook confirms HTTP 200 and service health
* ✅ Complete deployment playbook works end-to-end and is idempotent

---

## 🛡️ Why This Matters

Automated web server provisioning helps:

* eliminate configuration drift
* reduce manual errors
* speed up deployments (minutes instead of hours)
* enable reproducible infrastructure in DevOps pipelines
* provide auditable “infrastructure as code” artifacts

---

## 🧠 What I Learned

* Structuring Ansible projects for clarity and maintainability
* Using playbooks + tags for selective execution
* Using handlers to restart/reload services only when needed
* Using templates (Jinja2) to deploy dynamic web content
* Verifying deployments with built-in Ansible modules (`uri`, `wait_for`, `systemd`)
* Creating reusable master playbooks + included task files

---

## 🌍 Real-World Applications

* Standardized Apache provisioning for web fleets
* CI/CD integration for web infrastructure deployment
* Disaster recovery: rebuild infrastructure quickly from code
* Enforcing consistent web server configuration across environments
* Scaling web servers across many nodes using the same playbooks

---

## ✅ Conclusion

This lab demonstrated a full, production-style automation workflow for deploying Apache web servers using Ansible. I built a structured project, created repeatable playbooks, deployed custom web content using templates and files, opened firewall access, and verified the entire deployment using automated checks. The result is a reusable infrastructure-as-code baseline that can be applied consistently across multiple systems.

✅ Lab completed successfully on CentOS/RHEL 8 cloud environment
✅ Apache installed + configured + firewall opened + website deployed + verification passed
