# 🧪 Lab 09: Using Roles in Playbooks (Apache Web Server Role)

## 📌 Lab Summary
In this lab, I built a **custom Ansible role** to install and configure an **Apache (httpd) web server** on multiple managed nodes. The lab focused on understanding the **standard role directory structure**, implementing **tasks + handlers + templates + variables + metadata**, and then using the role inside playbooks (basic + advanced) with overrides.

To keep the repo safe and portfolio-ready, any training-platform branding strings were replaced with **neutral placeholders** (e.g., “Training Lab”) while keeping the **automation logic unchanged**.

---

## 🎯 Objectives
By the end of this lab, I was able to:

- Understand the concept and benefits of **Ansible roles**
- Create a custom role to install and configure **Apache HTTP Server**
- Organize role components into the correct role directories:
  - `tasks/`, `handlers/`, `templates/`, `defaults/`, `vars/`, `meta/`
- Include roles in playbooks effectively
- Override role defaults using:
  - playbook `vars`
  - role-level `vars`
- Apply role-based automation for consistent web server configuration
- Implement best practices for role structure and organization

---

## ✅ Prerequisites
- Linux command line basics
- YAML structure familiarity
- Previous experience with simple Ansible playbooks
- Understanding of Apache HTTP server concepts
- Knowledge of directory structure + file permissions

---

## 🖥️ Lab Environment
- **Platform:** Cloud lab environment (pre-configured)
- **Control Node:** Ansible pre-installed
- **Managed Nodes:** 2 web servers (`node1`, `node2`)
- **SSH:** Key-based authentication configured
- **Editors:** `nano`, `vim`

---

## 📁 Folder Name
`lab09-using-roles-in-playbooks/`

---

## 🗂️ Repository Structure
```text
lab09-using-roles-in-playbooks/
├── README.md
├── commands.sh
├── output.txt
├── interview_qna.md
├── troubleshooting.md
├── inventory.ini
├── deploy-webserver.yml
├── deploy-webserver-advanced.yml
├── site.yml
├── validate-deployment.yml
├── role-structure-guide.txt
└── roles/
    ├── apache-webserver/
    │   ├── README.md
    │   ├── defaults/main.yml
    │   ├── vars/main.yml
    │   ├── tasks/main.yml
    │   ├── handlers/main.yml
    │   ├── templates/index.html.j2
    │   ├── templates/vhost.conf.j2
    │   └── meta/main.yml
    └── common/
        ├── defaults/main.yml
        └── tasks/main.yml
````

---

## ✅ Tasks Overview (What I Did)

### 🧱 Task 1: Understand Role Structure

* Created a role folder layout manually (standard Ansible structure)
* Verified the structure with `tree`
* Documented each directory’s purpose in `role-structure-guide.txt`

---

### ⚙️ Task 2: Build a Custom Apache Role (Tasks + Variables)

* Created `roles/apache-webserver/tasks/main.yml` to:

  * install Apache package
  * start + enable service
  * create document root
  * deploy `index.html` from template
  * deploy virtual host config from template
  * attempt HTTP firewall opening (errors ignored to avoid hard-fail)
* Created default variables (`defaults/main.yml`)
* Created override variables (`vars/main.yml`) for port/performance/security flags

---

### 🔁 Task 3: Add Handlers

* Implemented handler actions:

  * restart / reload / start / stop Apache
* Triggered handlers via `notify` from tasks when templates change

---

### 🧩 Task 4: Create Templates

* Built dynamic Jinja2 templates:

  * `index.html.j2` showing host + OS + IP info
  * `vhost.conf.j2` with security/performance settings + headers

---

### 🧾 Task 5: Add Role Metadata

* Created `meta/main.yml` with platforms, tags, and role info

---

### 🚀 Task 6–7: Use the Role in Playbooks + Execute

* Created a basic role-based playbook: `deploy-webserver.yml`
* Created an advanced playbook: `deploy-webserver-advanced.yml` to override variables
* Built inventory: `inventory.ini`
* Ran both playbooks and validated:

  * role executed correctly
  * templates deployed
  * Apache running and reachable via `curl`

---

### 🧱 Task 8: Multiple Roles in a Single Play

* Created a `common` role for baseline system setup:

  * update packages
  * install utility packages
  * set timezone
* Created `site.yml` using both roles:

  * `common`
  * `apache-webserver`

---

### ✅ Task 9: Role Testing & Validation

* Created `validate-deployment.yml` to assert:

  * Apache is running (service facts + assert)
  * HTTP returns 200 (`uri`)
  * Custom `index.html` exists (`stat` + assert)
* Created role documentation file: `roles/apache-webserver/README.md`

  * cleaned up broken markdown formatting while keeping the content intact

---

## ✅ Verification (High-Level)

* Confirmed web server responds:

  * `curl http://<node-ip>`
* Confirmed Apache is running/enabled via Ansible service module
* Confirmed Apache syntax is OK:

  * `httpd -t`
* Confirmed validation playbook assertions pass

---

## 🏁 Result

✅ Successfully built and executed a **custom Apache role** with templates, variables, handlers, and metadata, then reused it across multiple playbooks and validated deployment across multiple servers.

---

## 🌍 Why This Matters

Roles are the foundation of **maintainable infrastructure automation**:

* reusable across environments (dev/stage/prod)
* consistent configuration standards across fleets
* easier collaboration (teams can own roles independently)
* easier troubleshooting (clear separation of concerns)

This is a core skill for real-world Ansible usage and enterprise automation.

---

## 🧠 What I Learned

* How Ansible role structure maps to production automation workflows
* Variable precedence in practice (`defaults` < `vars` < play vars)
* How handlers create reliable “change-driven” restarts/reloads
* How templates make deployments dynamic and host-aware
* How to validate infrastructure using assertions and `uri`

---

## ✅ Conclusion

This lab strengthened my ability to build **clean, reusable role-based automation** and deploy it reliably across multiple systems with structured validation. The same approach applies directly to larger infrastructure use cases (multi-service stacks, standardized baselines, and scalable configuration management).

✅ Lab completed successfully.
