# 🧪 Lab 17: Orchestrating Multiple Tasks (Ansible)

## 📌 Lab Summary
This lab focused on **orchestrating a complete multi-tier application stack** using Ansible by splitting a complex deployment into multiple playbooks and executing them in a controlled sequence.

The orchestration workflow deployed:

1. **Database server** (must be ready first)
2. **Web application servers** (depend on the database)
3. **Load balancer** (depends on web servers)
4. **Monitoring setup** (depends on all components)
5. **Validation phase** (ensures the entire stack is working)

The lab also included:
- Dependency checks and system prerequisite validation
- Variable/fact sharing across hosts (`hostvars` + `set_fact`)
- Tag-based execution for partial deployments
- A rollback playbook for recovery scenarios

---

## 🎯 Objectives
By the end of this lab, I was able to:

- Create and organize multiple Ansible playbooks for complex system orchestration
- Implement task dependencies and execution order control
- Use playbook imports to structure multi-playbook workflows
- Handle error conditions and rollback scenarios in orchestrated deployments
- Manage variable passing between different playbooks and tasks
- Implement conditional execution based on system states and prerequisites

---

## ✅ Prerequisites
Before performing this lab, the following knowledge was required:

- Basic understanding of Ansible playbooks and YAML syntax
- Familiarity with Linux command line operations
- Knowledge of SSH key-based authentication
- Understanding of basic system administration concepts
- Completion of previous Ansible labs covering playbook basics

---

## 🧰 Lab Environment
**Environment Type:** Cloud lab environment (RHEL/CentOS-based)  
**Control Node:** CentOS/RHEL 8 with Ansible pre-installed  
**Managed Nodes:** 3 target systems (web servers, database server, load balancer)  
**Connectivity:** SSH keys configured for passwordless authentication  

**Inventory roles (logical stack):**
- `database_servers` → MariaDB
- `web_servers` → Apache + PHP application
- `load_balancer` → HAProxy
- `localhost` → orchestration + validation execution

---

## 🏗️ What I Built (High-Level)
### ✅ Orchestration (Multi-playbook workflow)
- Created a **master playbook** (`site.yml`) that imports each component playbook in strict order:
  - database → web servers → load balancer → monitoring → validation

### ✅ Dependency Handling
- Implemented a **dependency validation playbook**:
  - host-to-host reachability checks
  - disk space assertions
  - basic port availability checks

### ✅ Configuration via Templates
- Used **Jinja2 templates** to dynamically generate:
  - PHP application config file pointing to the DB host
  - Apache virtual host config
  - HAProxy configuration with backend web servers

### ✅ Validation + Monitoring
- Deployed basic monitoring tooling (`htop`, `iotop`, `net-tools`)
- Added a cron-based `system-status.sh` script for periodic logging
- Performed validation checks to confirm:
  - DB connectivity
  - web servers respond
  - load balancer serves the application

### ✅ Rollback Capability
- Created a rollback playbook to:
  - stop stack services
  - remove application files/configs
  - remove firewall rules (best-effort with ignore_errors)

---

## 🔄 Execution Flow (Orchestration Order)
1. Create project structure (folders for inventory, playbooks, group_vars, templates)
2. Create master orchestration playbook (`site.yml`)
3. Build component playbooks:
   - `database.yml`
   - `webservers.yml`
   - `loadbalancer.yml`
   - `monitoring.yml` (includes validation play)
4. Add templates for:
   - PHP config
   - Apache vhost
   - HAProxy config
5. Create inventory + group variables
6. Run dependency check playbook
7. Run full orchestration playbook
8. Run specific phases using tags (database/webservers/loadbalancer)
9. Create rollback playbook
10. Validate services, firewall rules, and overall functionality

---

## 🧾 Repository Structure
```text
lab17-orchestrating-multiple-tasks/
├── README.md
├── commands.sh
├── output.txt
├── interview_qna.md
├── troubleshooting.md
├── inventory/
│   └── hosts
├── group_vars/
│   └── all.yml
├── playbooks/
│   ├── site.yml
│   ├── database.yml
│   ├── webservers.yml
│   ├── loadbalancer.yml
│   ├── monitoring.yml
│   ├── dependency_check.yml
│   └── rollback.yml
└── templates/
    ├── app_config.php.j2
    ├── webapp.conf.j2
    └── haproxy.cfg.j2
````

---

## ✅ Verification & Validation Performed

Validation was performed in multiple ways:

* **Pre-deployment validation**

  * `dependency_check.yml` confirmed:

    * system reachability across nodes
    * sufficient disk space
    * basic port availability

* **Deployment verification**

  * Database service running + DB/user creation successful
  * Web servers deployed and serving application
  * Load balancer configured and returning HTTP 200
  * Monitoring tools installed and `system-status.sh` scheduled

* **Post-deployment validation**

  * Stack validation play confirmed:

    * DB connectivity works
    * web servers respond correctly
    * load balancer responds successfully
    * application accessible via load balancer URL

---

## 🧠 What I Learned

* How to break a complex deployment into **separate playbooks** while keeping a controlled execution order
* Using `import_playbook` for **multi-stage orchestration**
* Fact/variable sharing between hosts using:

  * `set_fact`
  * `hostvars`
  * group variables in `group_vars/all.yml`
* Designing playbooks with **pre_tasks / post_tasks** for reliability checks
* Using **tags** to selectively deploy or re-run only one phase
* Implementing a rollback plan for safer deployments

---

## 🌍 Why This Matters

Real-world production deployments are rarely a single playbook. Enterprise systems require:

* **dependency-aware sequencing**
* **repeatable deployments (IaC)**
* **partial rollouts**
* **validation gates**
* **rollback strategy**

This lab mirrors real DevOps workflows used in:

* multi-tier web application deployments
* environment provisioning
* release automation
* infrastructure recovery scenarios

---

## 🧩 Real-World Applications

* Deploying database + application + load balancer stacks
* Rolling out infrastructure changes across multiple systems safely
* Performing staged deployments with validation checkpoints
* Building reusable infrastructure patterns using templates and shared variables
* Creating rollback playbooks for disaster recovery readiness

---

## ✅ Result

* ✅ Dependency checks passed on all nodes
* ✅ Database deployed successfully (MariaDB installed, running, DB/user created)
* ✅ Web servers deployed successfully (Apache + PHP app configured)
* ✅ Load balancer deployed successfully (HAProxy configured + validated)
* ✅ Monitoring installed + scheduled logging created
* ✅ Full validation confirmed stack is accessible via load balancer (`http://lb1`)
* ✅ Tag-based re-runs for phases worked as expected (`--tags database`, `--tags webservers`, `--tags loadbalancer`)

---

## 🏁 Conclusion

This lab successfully demonstrated **multi-playbook orchestration in Ansible** by deploying a complete application stack with proper sequencing, dependency checks, validation, and rollback planning.

I now have a strong foundation for orchestrating real-world multi-system deployments using Ansible and can confidently apply these principles to larger environments (including cloud and container-based systems).
