# 🧪 Lab 11: Automating Software Packages (yum/dnf + apt + Universal + Reporting)

## 📌 Lab Summary
This lab focused on automating **package installation, updates, removals, and reporting** across mixed Linux environments using Ansible. It covered:

- Using `yum`/`dnf` for Red Hat-based hosts and `apt` for Debian-based hosts
- Conditional package management using `when: ansible_os_family == ...`
- OS-specific playbooks (RHEL-only and Ubuntu-only)
- A universal playbook using the `package` module with OS-family mappings
- Robust playbooks using **block/rescue** for error handling and resilience
- Generating **package management reports** across the fleet for visibility and audit support

---

## 🎯 Objectives
By the end of this lab, I was able to:

- Automate software package install/update/remove across multiple systems
- Use Ansible package modules effectively:
  - `yum` / `dnf` (Red Hat family)
  - `apt` (Debian family)
  - `package` (universal abstraction when possible)
- Manage repositories and dependencies
- Implement conditional logic based on OS family
- Handle optional package failures gracefully using `block` + `rescue`
- Generate reporting artifacts that summarize system/package status across nodes

---

## ✅ Prerequisites
- Linux CLI familiarity
- Understanding of yum/dnf and apt basics
- Previous Ansible lab experience (inventory, playbooks, modules)
- YAML syntax familiarity
- SSH key-based authentication knowledge

---

## 🖥️ Lab Environment
- **Platform:** Cloud lab environment (pre-configured)
- **Control Node:** CentOS/RHEL 8 (or Ubuntu 20.04) with Ansible installed
- **Managed Nodes:** 3 total
  - 2 × RHEL/CentOS (`node1`, `node2`)
  - 1 × Ubuntu (`node3`)
- **SSH:** Pre-configured connectivity
- **Inventory:** Mixed groups (`rhel_servers`, `ubuntu_servers`) and combined group (`all_servers`)

---

## 🗂️ Repository Structure
```text
lab11-automating-software-packages/
├── README.md
├── commands.sh
├── output.txt
├── interview_qna.md
├── troubleshooting.md
├── inventory/
│   └── hosts
└── playbooks/
    ├── install-basic-packages.yml
    ├── advanced-package-management.yml
    ├── rhel-package-management.yml
    ├── ubuntu-package-management.yml
    ├── universal-package-management.yml
    ├── robust-package-management.yml
    └── package-reporting.yml
````

---

## ✅ Tasks Overview (What I Did)

### 📁 Task 1: Setup Inventory + Basic Package Installation

* Created an organized directory structure:

  * `~/ansible-lab11/inventory`
  * `~/ansible-lab11/playbooks`
* Created inventory groups:

  * `rhel_servers` (node1, node2)
  * `ubuntu_servers` (node3)
  * `all_servers` (children group)
* Verified connectivity with `ansible -m ping`

Then created and ran a basic package installation playbook:

* Installs common tools:

  * git, curl, wget, vim, htop
* Uses OS-family conditionals:

  * `yum` for Red Hat
  * `apt` for Debian
* Verifies Git version post-install

---

### 🧰 Task 1.3: Advanced Package Management (Install + Remove)

* Built `advanced-package-management.yml` to:

  * install development tools (python3, pip, nodejs, npm) per OS family
  * remove insecure legacy tools (`telnet`, `rsh`)
  * verify Python version per host

---

## ✅ Task 2: OS-Specific Playbooks for Package Management

### 🟥 RHEL/CentOS Playbook

* Updates packages to latest
* Installs admin tools and EPEL packages
* Adds Docker CE repository (if missing)
* Installs and enables Docker service
* Verifies package presence using rpm query

### 🟦 Ubuntu Playbook

* Updates apt cache + upgrades packages
* Installs utilities and monitoring tools
* Adds Docker repo + GPG key
* Installs Docker CE and enables service
* Installs Python packages via pip
* Verifies packages using `dpkg -l`

---

## ✅ Task 2.2: Universal Package Management

Created `universal-package-management.yml` that:

* Updates package cache based on OS family
* Installs web/database packages using OS mappings
* Starts correct web server service name per OS (httpd vs apache2)
* Starts database service
* Attempts monitoring packages (errors ignored for missing packages)
* Creates an index.html file and validates reachability using `uri`

---

## ✅ Task 2.3: Robust Package Management (Error Handling + Rollback Prep)

Created `robust-package-management.yml` to:

* Back up current installed package list (`rpm -qa` or `dpkg -l`)
* Install **critical packages** with strict error handling (fail if broken)
* Install **optional packages** with graceful failure handling (log + continue)
* Verify critical services (sshd)
* Generate post-install package list
* Write a host-specific installation summary report into `/tmp/package_backup/`

This demonstrates enterprise-safe automation patterns using:

* `block`
* `rescue`
* logging + continuation for non-critical failures

---

## ✅ Task 2.4: Package Management Reporting (Dashboard-style Output)

Created `package-reporting.yml` to:

* Collect package counts, available updates, uptime, and system facts
* Generate per-host reports under `/tmp/ansible_reports/` (on the control node)
* Append Docker version/service presence status

Reports included:

* OS family + distro version
* package counts and update count
* memory + disk stats
* uptime
* Docker presence and version

---

## 🏁 Result

✅ Package management automation completed successfully across mixed OS hosts:

* Basic + advanced installation playbooks executed correctly
* RHEL and Ubuntu package management playbooks installed Docker + tools
* Universal playbook worked across OS families and validated HTTP response
* Robust playbook successfully handled optional package failures using rescue logic
* Reporting playbook generated readable per-host reports on the control node

---

## 🌍 Why This Matters

Package automation is a core enterprise need because it:

* ensures consistent tooling and security baselines
* reduces manual errors and speeds up deployments
* supports compliance by keeping systems updated
* scales across large server fleets
* improves audit readiness through reporting and artifacts

---

## 🧠 What I Learned

* How to write OS-conditional package tasks (RedHat vs Debian)
* How to structure playbooks by scope (basic → OS-specific → universal → robust)
* How to safely handle failures with `block/rescue`
* How to generate fleet-level reporting artifacts useful for audits and operations
* How to manage repos and install Docker in automated workflows

---

## ✅ Conclusion

This lab strengthened my ability to manage packages across different Linux families using Ansible—covering installation, upgrades, removals, validation, error handling, and reporting. These are foundational skills for enterprise configuration management and automation.

✅ Lab completed successfully.
