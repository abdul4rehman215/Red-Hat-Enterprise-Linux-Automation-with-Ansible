# 🧪 Lab 08: Writing Complex Playbooks (Multi-Play + Roles)

## 📌 Lab Summary
This lab focuses on building **production-style Ansible automation** by organizing a complex deployment into:

- ✅ **Multiple plays** (database setup, web server setup, application deployment, verification)
- ✅ **Reusable roles** (MySQL role, Apache role, WebApp role)
- ✅ **Templates + handlers + group variables**
- ✅ **End-to-end validation** using Ansible testing playbooks and ad-hoc checks

The outcome is a **multi-tier web application stack** deployed across **web servers + database servers** using best-practice Ansible architecture.

---

## 🎯 Objectives
By the end of this lab, I was able to:

- Break complex automation into **logical multi-play structure**
- Convert tasks into **roles** for maintainability and reuse
- Build a **multi-tier deployment** (web + database + app)
- Use **variables, templates, and handlers** effectively
- Implement **pre-tasks and post-tasks** for preparation and verification
- Run structured deployments using **tags**
- Validate deployments with a dedicated **testing playbook**

---

## ✅ Prerequisites
- Basic understanding of **Ansible playbooks, tasks, modules**
- YAML syntax familiarity
- Linux CLI skills
- Knowledge of **Apache/Nginx** and **MySQL/PostgreSQL**
- Completion of earlier Ansible labs
- Basic networking concepts (ports, services, firewall)

---

## 🖥️ Lab Environment
- **Platform:** Cloud lab environment (pre-configured)
- **Control Node:** CentOS/RHEL 8 (Ansible installed)
- **Web Nodes:** 2 × CentOS/RHEL 8 (`web1`, `web2`)
- **Database Nodes:** 2 × CentOS/RHEL 8 (`db1`, `db2`)
- **SSH Auth:** Key-based access configured

---

## 🗂️ Repository Structure
```text
lab08-writing-complex-playbooks/
├── README.md
├── commands.sh
├── output.txt
├── interview_qna.md
├── troubleshooting.md
├── inventory.ini
├── site.yml
├── site-with-roles.yml
├── complete-deployment.yml
├── test-deployment.yml
├── group_vars/
│   ├── all.yml
│   ├── database_servers.yml
│   └── web_servers.yml
├── roles/
│   ├── mysql/
│   │   ├── defaults/main.yml
│   │   ├── handlers/main.yml
│   │   ├── tasks/main.yml
│   │   └── templates/my.cnf.j2
│   ├── apache/
│   │   ├── defaults/main.yml
│   │   ├── handlers/main.yml
│   │   ├── tasks/main.yml
│   │   └── templates/vhost.conf.j2
│   └── webapp/
│       ├── defaults/main.yml
│       ├── tasks/main.yml
│       └── templates/
│           ├── config.php.j2
│           ├── index.php.j2
│           └── dbtest.php.j2
└── templates/
    └── deployment-report.j2
````

---

## ✅ Tasks Overview (What I Performed)

### 🧩 Task 1: Multi-Play Architecture (Complex Stack)

* Created a structured Ansible project directory
* Built a **3-play** playbook:

  1. Configure DB servers
  2. Configure web servers
  3. Deploy application
* Defined inventory groups for `web_servers` and `database_servers`
* Ran a **--check** dry run first, then deployed for real

---

### 🧱 Task 2: Role-Based Organization

* Converted the multi-play deployment into reusable roles:

  * `roles/mysql` (packages, service, users/db creation, firewall, templates, handlers)
  * `roles/apache` (Apache + PHP install, vhost template, firewall, handler)
  * `roles/webapp` (deploy templates for app + db test pages)
* Added **templates** and **handlers** for service restarts

---

### 🚀 Task 3: Full Production-Style Deployment

* Built a full deployment playbook:

  * **Pre-deployment tasks:** update OS, install common tools, set timezone, enable firewalld
  * **DB play:** precheck disk, deploy MySQL role, post-check service + DB connectivity
  * **Web play:** check package availability, deploy apache + webapp roles, test endpoint
  * **Post-deployment verification:** uptime, memory usage, generate report on control node
* Created `deployment-report.j2` to output deployment summary to `/tmp/deployment-report.txt`
* Added `test-deployment.yml` for post-deployment automated testing

---

## ✅ Verification & Validation

* Validated playbook structure using:

  * `ansible-playbook --check`
  * Role-based deployment with tags (e.g., `--tags preparation,database`)
* Verified services using:

  * `systemd` status checks (MySQL + Apache)
  * `uri` module for HTTP endpoint validation
* Tested DB connectivity:

  * direct MySQL test from DB nodes
  * PHP database connectivity test via `dbtest.php`

---

## 🏁 Result

✅ Successfully deployed a **multi-tier application** using best-practice Ansible architecture:

* Roles deployed across **multiple servers**
* Firewall configured for **HTTP/HTTPS and MySQL**
* Application templates generated correctly
* Automated tests passed for:

  * MySQL service and DB access
  * Apache service and HTTP reachability
  * Web-to-DB connectivity validation

---

## 🌍 Why This Matters

This lab mirrors real enterprise automation where you manage:

* Multi-server infrastructure deployments
* Role-based reusable automation
* Pre/post validation and reporting
* Modular code design for scaling to large environments

This is a core skill set for:

* DevOps / Cloud Operations
* Infrastructure Automation Engineer
* Linux System Administration
* Enterprise automation using Ansible in production environments

---

## 🧠 What I Learned

* How to structure Ansible automation with **multi-play design**
* Why **roles** improve maintainability and scaling
* How to use:

  * **group_vars** to manage environment-specific settings
  * **templates** for configuration deployment
  * **handlers** for controlled service restarts
  * **tags** for targeted deployments
* How to test deployments using a **dedicated testing playbook**

---

## ✅ Conclusion

This lab strengthened my ability to build **complex, real-world Ansible automation** by:

* Structuring playbooks in a scalable way
* Organizing automation into roles
* Implementing end-to-end verification
* Producing deployment reports for operational visibility

This provides a strong foundation for advanced Ansible automation and aligns closely with enterprise deployment workflows.

✅ Lab completed successfully.
