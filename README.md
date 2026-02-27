# 🧰 Red-Hat-Enterprise-Linux-Automation-with-Ansible - Enterprise Linux Automation Engineering Portfolio

> Playbooks • Roles • Infrastructure as Code • Orchestration • Security • Performance

### A complete **20-lab hands-on enterprise automation engineering series** progressing from Ansible foundations to production-grade multi-tier orchestration, secure secrets management, resilient automation patterns, and performance optimization.

### Simulates real-world **Infrastructure Engineering, DevOps automation, and enterprise configuration management workflows.**

---

<div align="center">
  
<!-- ========================= PLATFORM & STACK ========================= -->
![RHEL](https://img.shields.io/badge/OS%20%7C%20Red%20Hat-Enterprise%20Linux%208%20%7C%209-EE0000?style=for-the-badge&logo=redhat&logoColor=EE0000)
![CentOS](https://img.shields.io/badge/CentOS-Stream-purple?style=for-the-badge&logo=centos)
![OS](https://img.shields.io/badge/OS-Ubuntu%2020.04%2F22.04-orange?style=for-the-badge&logo=ubuntu)
![Linux](https://img.shields.io/badge/Linux-Automation-black?style=for-the-badge&logo=linux)
![Ansible](https://img.shields.io/badge/Ansible-Core%202.x-EE0000?style=for-the-badge&logo=ansible)
![YAML](https://img.shields.io/badge/YAML-Playbooks%20%26%20Roles-0A0A0A?style=for-the-badge&logo=yaml)
![Python](https://img.shields.io/badge/Python-Dynamic%20Inventory-3776AB?style=for-the-badge&logo=python&logoColor=white)
![Bash](https://img.shields.io/badge/Bash-Automation-4EAA25?style=for-the-badge&logo=gnubash&logoColor=white)

<!-- ========================= FOCUS ========================= -->
![Focus](https://img.shields.io/badge/Focus-Enterprise%20Automation-1f6feb?style=for-the-badge)
![IaC](https://img.shields.io/badge/IaC-Idempotent%20Infrastructure-2ea043?style=for-the-badge)
![Roles](https://img.shields.io/badge/Roles-Reusable%20Architecture-8b5cf6?style=for-the-badge)
![Orchestration](https://img.shields.io/badge/Orchestration-Multi--Tier%20Deployments-f59e0b?style=for-the-badge)
![Security](https://img.shields.io/badge/Security-Vault%20%26%20RBAC-ef4444?style=for-the-badge)

<!-- ========================= SCOPE & STATUS ========================= -->
![Labs](https://img.shields.io/badge/Labs-20%20Hands--On-22c55e?style=for-the-badge)
![Level](https://img.shields.io/badge/Level-Foundation%20%E2%86%92%20Advanced-6366f1?style=for-the-badge)
![Status](https://img.shields.io/badge/Status-Completed-success?style=for-the-badge)

<!-- ========================= REPO METADATA (update username/repo if needed) ========================= -->
![Repo Size](https://img.shields.io/github/repo-size/abdul4rehman215/Red-Hat-Enterprise-Linux-Automation-with-Ansible?style=for-the-badge)
![Stars](https://img.shields.io/github/stars/abdul4rehman215/Red-Hat-Enterprise-Linux-Automation-with-Ansible?style=for-the-badge)
![Forks](https://img.shields.io/github/forks/abdul4rehman215/Red-Hat-Enterprise-Linux-Automation-with-Ansible?style=for-the-badge)
![Last Commit](https://img.shields.io/github/last-commit/abdul4rehman215/Red-Hat-Enterprise-Linux-Automation-with-Ansible?style=for-the-badge)

</div>

---

## 🎯 Executive Summary

This portfolio demonstrates practical capability in:

- ✅ Infrastructure as Code (Idempotent Automation)
- ✅ Role-Based Architecture & Modular Design
- ✅ Cross-Platform Linux Automation (RHEL & Ubuntu)
- ✅ Network, Firewall, Web & Database Automation
- ✅ Secure Secrets Management (Ansible Vault)
- ✅ Resilient Automation (block/rescue, retries, validation-first execution)
- ✅ Multi-Tier Orchestration & Dependency Handling
- ✅ Playbook Optimization & Performance Benchmarking

This is execution-driven engineering work — not theoretical content.

Each lab includes:
- Structured playbooks
- Modular roles & templates
- Validation workflows
- Debugging & troubleshooting notes
- Production-safe automation patterns

The progression reflects real-world automation maturity:
**Foundations → Modular Design → Service Automation → Orchestration → Security → Performance Engineering**

---

## 📌 About This Repository

A structured 20-lab automation program focused on **Enterprise Linux system automation using Ansible**.

The labs are designed to build:

- Clean inventory architecture  
- Scalable role-based automation  
- Service lifecycle management  
- Environment-aware deployments  
- Secure credential handling  
- Reliable, idempotent infrastructure control  

All labs were executed in controlled RHEL/CentOS and Ubuntu environments, emphasizing repeatability, validation, and production-safe change management.

---

## 👤 Who This Repository Is For

- **Linux / RHEL Administrators** moving into automation
- **DevOps / Infra Engineers** building repeatable server deployments
- **Ansible learners** aiming for enterprise-grade playbook standards
- **Automation engineers** focusing on roles, orchestration, and reliability
- **Interview preparation** (architecture + debugging + best practices)

---

## 🗂️ Labs Index (1–20)

> Click any lab title to jump directly to its folder.

---

# 🗂 Lab Architecture Overview

### 🧱 Section 1: Ansible Foundations (Labs 1–7)

<div align="left">

![Category](https://img.shields.io/badge/Category-Foundations-1f6feb?style=for-the-badge)
![Focus](https://img.shields.io/badge/Focus-Inventory%20%7C%20Playbooks%20%7C%20Modules-0ea5e9?style=for-the-badge)
![Focus](https://img.shields.io/badge/Focus-Variables%20%7C%20Loops%20%7C%20Handlers-8b5cf6?style=for-the-badge)

</div>

| Lab | Title | Core Focus |
| --: | --- | --- |
| 01 | [Introduction to Ansible](./lab01-introduction-to-ansible) | Installation, inventory, connectivity, ad-hoc commands |
| 02 | [Understanding Playbooks](./lab02-understanding-playbooks) | Play structure, tasks/handlers, execution workflow |
| 03 | [Managing Inventory](./lab03-managing-inventory) | INI/YAML inventory, group/host vars, inventory tooling |
| 04 | [Introduction to Ansible Modules](./lab04-introduction-to-ansible-modules) | yum/apt/service/systemd and core modules |
| 05 | [Variables and Facts](./lab05-variables-and-facts) | precedence, set_fact, register, facts, Jinja2 |
| 06 | [Conditionals and Loops](./lab06-conditionals-and-loops) | when logic, list/dict loops, loop_control, dynamic logic |
| 07 | [Handlers and Notifications](./lab07-handlers-and-notifications) | notify/handlers, idempotency, flush_handlers |

**🧠 Skills Demonstrated (Labs 1–7)**  
- IaC mindset & idempotent automation  
- Inventory architecture (groups, vars, testing)  
- Jinja2 + variables/facts mastery  
- Logic control with loops/conditionals  
- Event-driven automation using handlers (production-safe restarts)

---

### 🧩 Section 2: Enterprise Automation (Labs 8–12)

<div align="left">

![Category](https://img.shields.io/badge/Category-Enterprise%20Automation-f59e0b?style=for-the-badge)
![Focus](https://img.shields.io/badge/Focus-Roles%20%7C%20Multi--Play%20Design-ef4444?style=for-the-badge)
![Focus](https://img.shields.io/badge/Focus-Config%20Mgmt%20%7C%20Packages%20%7C%20RBAC-22c55e?style=for-the-badge)

</div>

| Lab | Title | Core Focus |
| --: | --- | --- |
| 08 | [Writing Complex Playbooks](./lab08-writing-complex-playbooks) | multi-play, multi-tier automation, validation + reporting |
| 09 | [Using Roles in Playbooks](./lab09-using-roles-in-playbooks) | role structure, reuse, templates, role documentation |
| 10 | [Managing Files with Ansible](./lab10-managing-files-with-ansible) | copy/template, backups, permissions, env-specific configs |
| 11 | [Automating Software Packages](./lab11-automating-software-packages) | cross-platform pkg mgmt, repos, rollback patterns |
| 12 | [User and Group Management](./lab12-user-and-group-management) | RBAC automation, lifecycle workflows, verification reports |

**🧠 Skills Demonstrated (Labs 8–12)**  
- Role-based modular architecture (team-ready design)  
- Template-driven configuration management  
- Safe change control (backup/validate/permissions)  
- Cross-platform package automation + rollback thinking  
- Identity lifecycle automation (users/groups/RBAC)

---

### 🌐 Section 3: Infrastructure Services Automation (Labs 13–16)

<div align="left">

![Category](https://img.shields.io/badge/Category-Infrastructure%20Services-0f172a?style=for-the-badge)
![Focus](https://img.shields.io/badge/Focus-Network%20%7C%20Firewall%20Automation-6366f1?style=for-the-badge)
![Focus](https://img.shields.io/badge/Focus-Web%20%7C%20Database%20Provisioning-14b8a6?style=for-the-badge)

</div>

| Lab | Title | What You Automated |
| --: | --- | --- |
| 13 | [Automating Network Configuration](./lab13-automating-network-configuration) | static IPs, routes, DNS templates, validation + fetched reports |
| 14 | [Automating Firewall Configuration](./lab14-automating-firewall-configuration) | zones, services, ports, rich rules, backups + policy tests |
| 15 | [Configuring Web Servers with Ansible](./lab15-configuring-web-servers-with-ansible) | Apache install/config, content deploy, firewall, URI verification |
| 16 | [Database Configuration with Ansible](./lab16-database-configuration-with-ansible) | MySQL/PostgreSQL, users/dbs/privs, hardening, backups + monitoring |

**🧠 Skills Demonstrated (Labs 13–16)**  
- Network automation using NetworkManager (`nmcli`)  
- Firewall zoning + rich rules with validation and backups  
- Web deployment pipelines with `uri`/`wait_for` verification  
- Database provisioning, access control, hardening, backups + monitoring

---

### 🚀 Section 4: Advanced Automation (Labs 17–20)

<div align="left">

![Category](https://img.shields.io/badge/Category-Advanced%20Automation-111827?style=for-the-badge)
![Focus](https://img.shields.io/badge/Focus-Orchestration%20%7C%20Vault%20%7C%20Resilience-8b5cf6?style=for-the-badge)
![Focus](https://img.shields.io/badge/Focus-Optimization%20%7C%20Benchmarking%20Reports-22c55e?style=for-the-badge)

</div>

| Lab | Title | Focus |
| --: | --- | --- |
| 17 | [Orchestrating Multiple Tasks](./lab17-orchestrating-multiple-tasks) | multi-playbook ordering, dependencies, validation, rollback |
| 18 | [Ansible Vault for Sensitive Data](./lab18-ansible-vault-for-sensitive-data) | vault IDs, encrypted vars, secure execution workflows |
| 19 | [Error Handling and Debugging](./lab19-error-handling-and-debugging) | debug strategy, check/diff, retries, block/rescue/always |
| 20 | [Optimizing Playbooks and Performance](./lab20-optimizing-playbooks-and-performance) | roles refactor, async/delegate, benchmarking + reports |

**🧠 Skills Demonstrated (Labs 17–20)**  
- Orchestration with enforced dependency order (DB → Web → LB → Validate)  
- Vault-based secrets management with environment separation  
- Resilient deployment patterns (block/rescue/always + retries)  
- Performance tuning and measurable execution benchmarking

---

## 🧠 What This Portfolio Demonstrates

### ✅ Enterprise Automation Patterns

* **Idempotent playbooks** (repeatable, safe, predictable)
* **Role-based architecture** for maintainability and reuse
* **Validation & reporting** (post-deploy verification, health checks)
* **Rollback thinking** (clean removal paths and rescue patterns)
* **Cross-platform automation** (RHEL/CentOS + Ubuntu)

### ✅ Reliability & Safety

* `--check` / `--diff` rollout discipline
* `assert`, `debug`, `register`, `failed_when`, `changed_when` patterns
* `block/rescue/always` and retry/delay strategies
* Handlers used to prevent unnecessary restarts

### ✅ Security & Governance

* **Ansible Vault** secrets handling (no plaintext credentials)
* **User/group automation** aligned with RBAC workflows
* Firewall baselines and port exposure control

---

## 🧰 Tools & Technologies Used Across Repository

<details>
<summary><b>Click to expand</b></summary>

### 🧠 Automation Engine & Architecture

- **Ansible Core 2.x**
- YAML Playbooks (`hosts`, `tasks`, `handlers`, `pre_tasks`, `post_tasks`)
- **Roles Architecture** (tasks/, handlers/, defaults/, vars/, templates/, meta/)
- Inventory Management (INI, YAML, group_vars, host_vars)
- Tags, conditionals, loops, variable precedence
- Dynamic inventory concepts (Python-based)

### 🧩 Infrastructure as Code (IaC)

- Jinja2 templating (`.j2`)
- `set_fact`, `register`, `assert`, `debug`
- Idempotent execution patterns
- `block / rescue / always`
- Validation-first automation (`--check`, `--diff`)
- Structured reporting via templates

### 🖥️ Operating Systems / Platforms

- **RHEL 8+**
- **CentOS Stream**
- **Ubuntu 20.04 / 22.04**
- Multi-node SSH-based lab topology

### 📦 Package & Repository Management

- `yum`, `dnf`, `apt`
- `package` module
- `yum_repository`, `apt_repository`
- Cross-platform conditionals

### 🌐 Networking & Firewall Automation

- **NetworkManager (`nmcli`)**
- `community.general.nmcli`
- `firewalld` module
- `firewall-cmd` (zones, services, rich rules)
- UFW (where applicable)
- Validation: `ss`, `curl`, `wait_for`

### 🌍 Web & Application Services

- **Apache HTTP Server (httpd)**
- Virtual host templating
- Service management via `systemd`
- `uri` module for validation
- Content deployment (`copy`, `template`)

### 🗄️ Database Provisioning

- **MySQL / MariaDB**
- **PostgreSQL**
- `mysql_db`, `mysql_user`
- Privilege management
- Remote access configuration
- Backup automation via `cron`

### 👥 Identity & Access Automation

- `user`, `group` modules
- UID/GID management
- Password aging & account locking
- RBAC enforcement patterns

### 🔐 Security & Secrets Management

- **Ansible Vault**
- `ansible-vault encrypt / decrypt / edit`
- Vault IDs (dev/prod separation)
- Secure execution (`--ask-vault-pass`)
- SSH-based automation security

### ⚙️ Orchestration & Performance Engineering

- `import_playbook`
- Dependency sequencing via `hostvars`
- `async`, `poll`, `async_status`
- `delegate_to`, `run_once`
- `strategy: free`
- Benchmarking scripts & execution timing analysis

### 🛠️ Supporting Linux Utilities

- `ssh`
- `systemctl`
- `cron`
- `ss`, `netstat`
- `nslookup`
- `curl`
- `tar`, `gzip`
- Bash scripting for automation helpers

</details>

---

# 📁 Repository Structure

```

Red-Hat-Enterprise-Linux-Automation-with-Ansible/
│
├── 🔹 Ansible Foundations (Labs 1–7)
├── 🔹 Enterprise Automation (Labs 8–12)
├── 🔹 Infrastructure Services Automation (Labs 13–16)
├── 🔹 Advanced Automation (Labs 17–20)
└── README.md

````

## 📦 Standard Lab Folder Structure

Each lab follows a consistent, production-style automation layout:

```text
labXX-<topic>/
│
├── README.md                # Objectives, architecture overview, execution guide
├── inventory.ini            # Target hosts & group definitions
│
├── playbooks/               # Main playbooks (single or multi-play)
│   ├── site.yml
│   └── validation.yml
│
├── roles/                   # Modular role-based architecture (when applicable)
│   ├── tasks/
│   ├── handlers/
│   ├── defaults/
│   ├── vars/
│   ├── templates/
│   └── meta/
│
├── group_vars/              # Group-level variables
├── host_vars/               # Host-level variables
│
├── templates/               # Jinja2 configuration templates
├── files/                   # Static files (configs/scripts/assets)
│
├── reports/                 # Generated reports / fetched outputs (where applicable)
├── ansible.cfg              # Local execution configuration (Lab 20, when used)
├── troubleshooting.md       # Common issues, debugging steps, fixes
└── interview_qna.md
````

---

### 🔎 Design Principles Across Labs

* Clean inventory hierarchy
* Idempotent task execution
* Validation-first deployments
* Modular role-based design
* Secure variable management
* Structured troubleshooting documentation
* Performance-aware automation patterns

This structure mirrors how Ansible projects are organized in **enterprise infrastructure environments**, not simple single-file demo playbooks.

---

## 🎓 Learning Outcomes Across 20 Labs

After completing all 20 labs, this repository demonstrates the ability to:

- Design structured **enterprise Ansible inventories** (groups, vars, hierarchy)
- Build modular **role-based automation architectures**
- Implement **idempotent Infrastructure-as-Code workflows**
- Automate networking, firewall, web, and database services
- Apply secure automation using **Ansible Vault**
- Enforce RBAC with automated user & group lifecycle management
- Use **validation-first deployment strategies** (check mode, diff, assertions)
- Implement resilient automation with **block/rescue/always patterns**
- Orchestrate multi-tier infrastructure with dependency awareness
- Optimize playbooks using async, delegation, and performance benchmarking

This reflects **practical infrastructure automation capability — not theoretical study.**

---

## 🧩 Real-World Alignment

These labs simulate real enterprise automation workflows including:

- Standardized Linux server provisioning (RHEL/CentOS/Ubuntu)
- Configuration management at scale (templates + validation)
- Firewall baseline enforcement and network automation
- Secure secrets handling across environments (dev/prod separation)
- Multi-tier deployment orchestration (DB → Web → Validation)
- Change management discipline (idempotency + controlled restarts)
- Infrastructure reporting and performance analysis

---

## 📈 Professional Relevance

This portfolio reflects:

- Infrastructure Engineering & DevOps automation capability  
- Enterprise Linux system standardization expertise  
- Modular automation design for team environments  
- Secure configuration management practices  
- Reliability-focused deployment mindset  
- Performance-aware automation engineering  

It aligns strongly with roles such as:

- Linux Automation Engineer  
- DevOps Engineer  
- Infrastructure Engineer  
- Red Hat / Ansible Specialist  

---

## 🌍 Real-World Simulation

All labs were executed in controlled Linux environments and designed to simulate realistic **infrastructure engineering + DevOps automation workflows**:

- **Baseline provisioning** (packages, services, users, policies)
- **Configuration enforcement** (templates, permissions, backups, rollback thinking)
- **Network & security automation** (nmcli, firewalld zoning, rich rules validation)
- **Service delivery automation** (Apache deployment + URI validation checks)
- **Database provisioning** (MySQL/PostgreSQL users, DBs, privileges, hardening)
- **Operational resilience** (retries, rescue blocks, troubleshooting patterns)
- **Optimization mindset** (roles refactor + benchmark reports)

This is execution-focused implementation — not theoretical notes.

---

# 📊 Automation Engineering Skills Heatmap

This heatmap reflects **hands-on implementation across 20 labs** in:

**Ansible Foundations • Role-Based Architecture • Infrastructure as Code • Service Automation • Orchestration • Secure Automation • Performance Engineering**

> Exposure bars use text-block style similar to previous portfolio repositories.

| Skill Area | Exposure Level | Practical Depth | Tools / Modules Used |
|-------------|----------------|----------------|----------------------|
| 🧱 Ansible Core Foundations | ██████████ 100% | Inventory, ad-hoc commands, play structure, handlers | ansible, ansible-playbook |
| 📂 Inventory Architecture | ██████████ 100% | Group hierarchy, host_vars, group_vars, dynamic inventory | INI/YAML inventory |
| 🔁 Variables & Templating | ██████████ 100% | set_fact, register, Jinja2 templating, precedence handling | Jinja2, debug, assert |
| 🔄 Conditionals & Loops | ██████████ 100% | when logic, dict2items, nested loops, dynamic execution | loop_control, filters |
| 🧩 Role-Based Architecture | ██████████ 100% | tasks/handlers/defaults/meta/templates structuring | Ansible roles |
| 🌐 Network Automation | █████████ 90% | Static IP, DNS templating, route configuration | community.general.nmcli |
| 🔥 Firewall Automation | █████████ 90% | Zones, services, rich rules, validation checks | firewalld module |
| 🌍 Web Server Automation | █████████ 90% | Apache deployment, config templating, URI validation | httpd, uri, wait_for |
| 🗄 Database Provisioning | █████████ 90% | MySQL/PostgreSQL users, DBs, privileges, backups | mysql_db, mysql_user |
| 👥 Identity & RBAC Automation | █████████ 90% | User lifecycle, group mgmt, permission enforcement | user, group modules |
| 🔐 Secrets Management | █████████ 90% | Vault encryption, vault IDs, secure execution | ansible-vault |
| 🧯 Error Handling & Resilience | █████████ 90% | block/rescue/always, retries, safe rollout patterns | ignore_errors, failed_when |
| 🧭 Multi-Tier Orchestration | █████████ 90% | import_playbook, dependency sequencing, validation plays | hostvars, set_fact |
| ⚡ Performance Optimization | █████████ 90% | async, delegation, strategy tuning, benchmarking | async, delegate_to |
| 📈 Automation Reporting | █████████ 90% | Template-based reporting, structured outputs | Jinja2 reports |

## 🧠 Proficiency Scale

- ██████████ = Implemented End-to-End with Validation & Structured Design  
- █████████  = Advanced Practical Implementation in Multi-Host Scenarios  
- ███████    = Strong Working Implementation with Applied Context  
- █████      = Foundational + Applied Engineering Exposure  

This heatmap reflects **enterprise automation engineering capability**, not isolated scripting — covering:

> Provisioning → Configuration → Validation → Security → Orchestration → Optimization

---

## ▶️ How To Use

Clone the repository and execute labs individually.  
Each lab is self-contained and follows a consistent automation workflow.

### 1️⃣ Clone & Move Into Repository

```bash
git clone https://github.com/abdul4rehman215/Red-Hat-Enterprise-Linux-Automation-with-Ansible.git
cd Red-Hat-Enterprise-Linux-Automation-with-Ansible
````

### 2️⃣ Open Any Lab

```bash
cd labXX-lab-name
ls
cat README.md
```

Review the objective, architecture, and execution flow before running playbooks.

---

### 3️⃣ Validate Connectivity

```bash
ansible -i inventory.ini all -m ping
```

---

### 4️⃣ Execute Playbooks

```bash
ansible-playbook -i inventory.ini playbook.yml
```

---

### 5️⃣ Safe Execution Patterns (Recommended)

```bash
# Syntax validation
ansible-playbook -i inventory.ini playbook.yml --syntax-check

# Dry-run (no changes applied)
ansible-playbook -i inventory.ini playbook.yml --check

# Show configuration differences
ansible-playbook -i inventory.ini playbook.yml --diff

# Verbose debugging
ansible-playbook -i inventory.ini playbook.yml -vvv

# Execute specific tags
ansible-playbook -i inventory.ini playbook.yml --tags "install,config"
```

---

### 6️⃣ Vault-Based Labs (Secure Execution)

```bash
ansible-playbook -i inventory.ini playbook.yml --ask-vault-pass
# or
ansible-playbook -i inventory.ini playbook.yml --vault-password-file .vault_pass
```

---

> Each lab includes **setup steps, structured playbooks, validation commands, troubleshooting guidance, and automation design explanations** aligned with enterprise Linux automation practices.

---

## 🔐 Execution Environment

All labs were executed in controlled Linux lab environments designed for safe, repeatable, and production-style automation engineering.

**Environment characteristics:**

- Ubuntu 20.04 / 22.04 and RHEL/CentOS 8+ systems  
- Ansible Core 2.x with structured inventory layouts  
- SSH-based multi-node lab topology  
- Isolated test hosts for network, firewall, web, and database automation  
- Version-controlled playbooks and role-based project structures  
- Performance benchmarking and validation scripts (Lab 20)

Automation was validated using:
- `ansible-playbook --check` and `--diff`
- Service status checks (`systemctl`)
- Port validation (`ss`, `firewall-cmd`)
- HTTP verification (`uri`, `curl`)
- Database validation (`mysql`, `psql`)
- Structured troubleshooting workflows

The focus was on **safe, idempotent, production-aligned automation practices.**

---

## 🎯 Intended Use

This repository is designed to support:

- Enterprise Linux automation engineering  
- DevOps & Infrastructure-as-Code workflows  
- Configuration management standardization  
- Secure secrets handling with Ansible Vault  
- Service provisioning & lifecycle management  
- Role-based automation architecture design  
- Performance optimization & scaling strategies  

All playbooks and automation workflows are intended for:
- Authorized lab environments  
- Controlled enterprise infrastructure  
- Defensive and operational engineering use  

Execute responsibly within approved systems only.

---

## ⚖️ Ethical & Professional Notice

All automation demonstrated in this repository was conducted:

- In isolated lab environments  
- On authorized systems  
- For infrastructure engineering and automation training purposes  

No production systems were modified without authorization.

This repository reflects responsible, enterprise-focused automation engineering — designed for professional development, operational improvement, and secure infrastructure management.

---

## ⭐ Final Note

This repository reflects **execution-driven Enterprise Linux automation engineering** — not theory.

It demonstrates the ability to:

> **Design → Automate → Validate → Secure → Optimize**

Ansible is not just about writing playbooks.  
It is about **repeatable infrastructure, safe change control, and production-grade reliability.**

If this repository adds value, consider starring it ⭐

---

## 👨‍💻 Author

**Abdul Rehman**

Enterprise Linux Automation • Infrastructure as Code • DevOps Engineering • Ansible Architecture

### 📧 Reach Out

  <a href="https://github.com/abdul4rehman215">
    <img src="https://img.shields.io/badge/Follow-181717?style=for-the-badge&logo=github&logoColor=white" alt="Follow" />
  </a>  
  <a href="https://linkedin.com/in/abdul4rehman215">
     <img src="https://img.shields.io/badge/LinkedIn-0077B5?style=for-the-badge&logo=linkedin&logoColor=white&v=1" />
  </a>
  <a href="mailto:abdul4rehman215@gmail.com">
    <img src="https://img.shields.io/badge/Email-EE0000?style=for-the-badge&logo=gmail&logoColor=white" />
  </a>

---
