# 🧪 Lab 06: Conditionals and Loops in Ansible

## 🧾 Lab Summary
This lab focused on building **dynamic Ansible playbooks** using two core concepts:
1) **Conditionals (`when`)** to control task execution based on variables and host facts  
2) **Loops (`loop`, `dict2items`, `loop_control`)** to reduce repetition and handle lists/dictionaries cleanly

I created playbooks ranging from basic conditional installs to advanced resource-based decisions, dictionary-driven deployments, loop controls (custom loop variables, index variables, and pauses), and a multi-environment deployment scenario combining loops + conditionals. I also implemented error handling patterns using `service_facts`, `stat`, and conditional reporting.

---

## 🎯 Objectives
By the end of this lab, I was able to:

- Implement conditional logic using `when`
- Create and execute loops for repetitive tasks
- Control tasks based on Ansible facts and variables
- Use loop constructs for installing packages and managing configurations
- Combine conditionals + loops for dynamic automation
- Troubleshoot common issues with conditional and loop structures

---

## 📌 Prerequisites
Before starting this lab, the following knowledge was required:

- YAML syntax and structure
- Ansible playbook fundamentals (Labs 1–5)
- Ansible facts and variables
- Linux basics and package management concepts

---

## 🖥️ Lab Environment
- **Environment Type:** Cloud lab environment (pre-configured nodes)
- **Control Node:** Ansible pre-installed
- **Managed Nodes:** Two target servers (`centos1`, `ubuntu1`)
- **SSH:** Pre-configured SSH keys and inventory files

> ✅ Note: Some lab steps were RedHat-centric (e.g., `yum`, `httpd`) and required OS-aware logic to avoid breaking Ubuntu tasks. Where needed, modules were adjusted while keeping the lab intent (especially for loop demonstrations).

---

## 🗂️ Repository Structure
```text
lab06-conditionals-and-loops/
├── README.md
├── commands.sh
├── output.txt
├── interview_qna.md
├── troubleshooting.md
└── playbooks/
    └── lab6/
        ├── inventory
        ├── basic-conditionals.yml
        ├── advanced-conditionals.yml
        ├── basic-loops.yml
        ├── advanced-loops.yml
        ├── loop-control.yml
        ├── combined-logic.yml
        ├── error-handling.yml
        ├── multi-environment-deploy.yml
        ├── verify-lab.yml
        └── templates/
            └── app-config.j2
````

---

## ✅ Tasks Overview (What I Did)

### ✅ Task 1: Conditionals with `when`

#### Subtask 1.1: Basic Conditionals

* Installed Apache web server using OS-specific tasks:

  * `httpd` via `yum` on RedHat
  * `apache2` via `apt` on Debian
* Started Apache only when `environment_type == "production"`
* Installed development tools per OS family

#### Subtask 1.2: Advanced Conditionals

* Gathered installed package info using `package_facts`
* Checked system memory requirement (2GB threshold)
* Installed monitoring tools only when system meets RAM requirement (RedHat only)
* Configured firewall only if `firewalld` exists and OS is RedHat
* Created weekend backup directory only if weekday is Saturday/Sunday

---

### ✅ Task 2: Loops for Repetitive Tasks

#### Subtask 2.1: Basic Loops

* Installed multiple packages via `loop`
* Created multiple users via `loop`
* Created multiple directories via `loop`
* Printed debug messages per user using `loop`

#### Subtask 2.2: Advanced Loops (Complex Data)

* Used list-of-dictionaries (`web_applications`) to:

  * create users
  * create per-app directories
  * print app configurations
* Used dictionary iteration via `dict2items` (`database_configs`)
* Installed multiple packages with structured loop items (name/state) on RedHat

#### Subtask 2.3: Loop Control + Filtering

* Installed only packages marked as required (`when: item.required == true`)
* Created indexed directories using `loop_control.index_var`
* Customized loop variable name via `loop_control.loop_var`
* Implemented “pause between installations” using a loop + `pause` module

---

### ✅ Task 3: Combine Conditionals + Loops in One Real Scenario

#### Subtask 3.1: Combined Role-Based Logic

* Used role-driven mapping (`applications[server_role]`) to:

  * install packages (RedHat only)
  * start services only in production
  * open firewall ports (RedHat only)
  * create standard directory structure on all hosts
  * print a summary of computed configuration

#### Subtask 3.2: Error Handling + Validation

* Used `service_facts` to check service state
* Started only required services if not running
* Reported failures using `register` + result-loop
* Backed up important files only if they exist using `stat` + conditional copy loop

---

### ✅ Task 4: Practical Multi-Environment Deployment

* Implemented environment config mapping:

  * development / staging / production
* Installed environment-specific packages using loop filters
* Generated per-environment config using a Jinja2 template
* Configured logrotate only on staging/production
* Created backup cron only when enabled by environment config
* Installed monitoring tools only when enabled + RedHat OS
* Started required services only for non-development environments
* Produced a deployment summary message at the end

> ✅ Note: Some steps produced realistic cross-OS differences (e.g., `apache` user on Ubuntu vs `www-data`). These were treated as expected lab-style “realistic issues” and continued execution using ignore behavior where appropriate.

---

## ✅ Verification & Validation

The following checks confirmed successful lab completion:

* ✅ Conditionals ran correctly (OS-based installs, environment-based service start)
* ✅ Advanced conditional checks behaved as expected (RAM threshold, weekend-only task)
* ✅ Loops created packages/users/directories reliably on both nodes
* ✅ Complex loop data structures processed correctly (`dict2items`, nested dict access)
* ✅ Loop control worked (`index_var`, `loop_var`, pause block)
* ✅ Combined logic playbook executed and produced summaries
* ✅ Error-handling playbook validated services and backed up important files
* ✅ Verification playbook confirmed key artifacts existed (packages installed, users present, /opt/app* directories exist)

---

## 🧠 What I Learned

* How to build reliable `when` conditions using:

  * booleans
  * fact comparisons
  * list membership
  * `is defined`
* How to design loops for:

  * simple lists
  * list-of-dicts
  * dict iteration (`dict2items`)
* How to avoid common loop pitfalls:

  * variable naming collisions using `loop_control.loop_var`
  * indexing using `loop_control.index_var`
* How to combine both for real-world automation:

  * environment-driven configurations
  * role-based deployments
  * validation and error reporting patterns

---

## 🌍 Why This Matters

Conditionals and loops transform playbooks from static scripts into **intelligent automation**. They allow automation to adapt to different OS families, environments, and constraints—making your infrastructure automation scalable and production-ready.

---

## 🧩 Real-World Applications

* Multi-OS fleet automation (RHEL + Ubuntu)
* Role-based provisioning (web/database/monitoring)
* Environment-aware deployments (dev/staging/prod)
* Safe backups and validation gates before changes
* Robust automation pipelines with controlled, repeatable logic

---

## ✅ Result

* Multiple playbooks created demonstrating `when`, `loop`, `dict2items`, and `loop_control`
* Combined scenario playbooks executed successfully
* Error handling and verification included for reliability

✅ **Lab completed successfully on a cloud lab environment.**
