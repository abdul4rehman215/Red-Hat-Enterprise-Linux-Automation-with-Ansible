# 🧪 Lab 02: Understanding Playbooks (Ansible)

## 🧾 Lab Summary
This lab focused on building a strong foundation in **Ansible playbooks**—understanding their structure, organizing a playbook project directory, writing functional playbooks in YAML, and executing them against managed nodes. It also introduced **handlers**, **templates (Jinja2)**, **tags**, **syntax checks**, **check mode (dry-run)**, **debugging techniques**, **facts gathering**, and **error handling** using `ignore_errors` and `block/rescue/always`.

---

## 🎯 Objectives
By the end of this lab, I was able to:

- Understand the basic structure and components of Ansible playbooks
- Create functional playbooks to install packages on remote hosts
- Define and configure **hosts**, **tasks**, and **handlers**
- Execute playbooks using `ansible-playbook`
- Use task organization approaches and basic error handling patterns
- Improve YAML correctness (indentation + valid list syntax)
- Apply templates using Jinja2 (`.j2`) for dynamic content generation

---

## 📌 Prerequisites
Before starting this lab, the following knowledge was required:

- Basic Linux command line operations
- YAML syntax fundamentals
- Completion of Lab 01 (or equivalent Ansible basics)
- Understanding of SSH connectivity concepts
- Basic knowledge of Linux package management

---

## 🖥️ Lab Environment
- **Environment Type:** Cloud lab environment (pre-configured nodes)
- **Control Node:** CentOS/RHEL 8 (Ansible installed)
- **Managed Nodes:** Two nodes reachable via SSH
- **SSH Access:** Pre-configured connectivity using SSH keys
- **Working Directory:** `/home/ansible`

> ✅ Note: In this lab, the original lab text contained YAML formatting issues (invalid bullets + indentation).  
> YAML is indentation-sensitive, so corrections were applied while creating files.

---

## 🗂️ Repository Structure
```text
lab02-understanding-playbooks/
├── README.md
├── commands.sh
├── output.txt
├── interview_qna.md
├── troubleshooting.md
└── playbooks/
    └── lab2/
        ├── inventory.ini
        ├── install-package.yml
        ├── enhanced-playbook.yml
        ├── debug-playbook.yml
        ├── error-handling-playbook.yml
        ├── vars.yml
        ├── variable-playbook.yml
        ├── verify-setup.yml
        ├── group_vars/
        ├── host_vars/
        ├── roles/
        ├── files/
        ├── templates/
        │   └── index.html.j2
````

---

## ✅ Tasks Overview (What I Did)

### ✅ Task 1: Understand Playbook Structure + Build Lab Directory

* Navigated into `/home/ansible`
* Created a lab-specific playbook workspace at `playbooks/lab2`
* Created common Ansible directories:

  * `group_vars/`, `host_vars/`, `roles/`, `files/`, `templates/`

### ✅ Task 2: Create First Playbook (`install-package.yml`)

* Created a playbook to:

  * Install `httpd`
  * Start and enable the service
  * Deploy a simple `index.html`
  * Trigger handlers when content changes

### ✅ Task 3: Define Hosts + Custom Inventory (`inventory.ini`)

* Created a custom inventory containing:

  * host groups: `managed_nodes`, `web_servers`, `database_servers`
  * global variables under `[all:vars]` for SSH key and host checking
* Validated inventory parsing using `ansible-inventory --list`
* Verified connectivity using `ansible -m ping`
* Gathered facts and stored them using `setup --tree /tmp/facts`

### ✅ Task 4: Enhanced Playbook + Templates (`enhanced-playbook.yml`)

* Built an enhanced playbook to:

  * Install multiple packages (`httpd`, `firewalld`, `wget`)
  * Configure firewall HTTP access
  * Deploy Jinja2-generated HTML content (`templates/index.html.j2`)
  * Ensure services run correctly
  * Verify web service via `uri` module (delegated to localhost)
* Introduced **pre_tasks**, **tags**, **handlers**, and **post_tasks**

### ✅ Task 5: Execute Playbooks + Advanced Execution Options

* Executed playbooks with:

  * `-v` verbose output
  * `--syntax-check`
  * `--check` (dry-run)
  * selective execution using `--tags`
  * skipping tasks using `--skip-tags`
* Verified results using Ansible ad-hoc commands:

  * service module (httpd running)
  * shell+curl returning HTTP 200
  * file module check for index.html ownership and mode

### ✅ Task 6: Troubleshooting + Debugging

* Used `-vvv` for deeper troubleshooting
* Created a debug playbook (`debug-playbook.yml`) to:

  * inspect host variables with `hostvars[inventory_hostname]`
  * print specific facts for each node

### ✅ Task 7: Implement Error Handling

* Built `error-handling-playbook.yml` demonstrating:

  * `ignore_errors: yes`
  * `register` results and conditional debug output
  * `block/rescue/always` for graceful recovery
* Created reusable variables via `vars.yml`
* Built playbooks that apply different packages to web vs db nodes based on group membership
* Built a verification playbook (`verify-setup.yml`) to validate installation, service status, content, and HTTP response

---

## ✅ Verification & Validation

The following checks confirmed successful lab completion:

* ✅ Inventory parsed correctly: `ansible-inventory -i inventory.ini --list`
* ✅ Connectivity verified: `ansible -i inventory.ini managed_nodes -m ping`
* ✅ Facts gathered and stored: `setup --tree /tmp/facts`
* ✅ `httpd` installed and running
* ✅ `/var/www/html/index.html` exists with correct ownership (`apache:apache`) and mode (`0644`)
* ✅ Web server responds with HTTP **200 OK** from each node
* ✅ Enhanced playbook verification via `uri` succeeded
* ✅ Debugging and error handling playbooks executed successfully

---

## 🧠 What I Learned

* Playbook anatomy: **plays → tasks → modules → handlers**
* YAML strictness: indentation rules and valid list markers (`-`)
* How `notify` triggers handlers only when changes occur
* How to use inventories effectively with groups and global vars
* Using `setup` to collect facts and store them per-host with `--tree`
* Advanced playbook patterns:

  * `pre_tasks`, `post_tasks`
  * tags and selective runs
  * delegated tasks (`delegate_to: localhost`)
  * debugging with `debug` module
  * error handling with `ignore_errors` and `block/rescue/always`
* Writing reusable playbooks using external vars (`vars_files`)

---

## 🌍 Why This Matters

Playbooks are the core of Ansible automation. In real environments, playbooks are used to enforce consistent configuration across many servers, automate deployments, reduce human error, and implement infrastructure-as-code workflows.

---

## 🧩 Real-World Applications

* Automated configuration of web servers (Apache + firewall) across fleets
* Standardized service enablement and validation procedures
* Reliable rollback/failure handling using `rescue` blocks
* Environment auditing using facts collection
* Repeatable provisioning using reusable variables and templated config/content

---

## ✅ Result

* Multiple playbooks created and successfully executed
* Inventory grouping and host targeting validated
* Templating + firewall configuration automated
* Error handling patterns tested and verified
* Web services validated with HTTP 200 checks

✅ **Lab completed successfully on a cloud lab environment.**
