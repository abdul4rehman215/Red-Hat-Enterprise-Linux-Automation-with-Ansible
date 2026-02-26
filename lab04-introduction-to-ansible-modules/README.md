# 🧪 Lab 04: Introduction to Ansible Modules

## 🧾 Lab Summary
This lab introduced **Ansible modules** and how they power automation tasks. I explored module documentation using `ansible-doc`, validated inventory targeting across two Linux distributions, and built playbooks that automate package installation and service management using **yum**, **apt**, **package**, and **service** modules. The lab also covered cross-platform conditionals (`ansible_os_family`), verification using ad-hoc commands, and error handling patterns to make automation more reliable.

---

## 🎯 Objectives
By the end of this lab, I was able to:

- Understand what Ansible modules are and their role in automation
- Use common modules such as `yum`, `apt`, and `service`
- Write playbooks that manage packages and services on remote systems
- Create cross-platform playbooks using conditions and the `package` module
- Troubleshoot common issues when working with modules
- Apply module best practices for real-world automation scenarios

---

## 📌 Prerequisites
Before starting this lab, the following knowledge was required:

- Basic Linux command line operations
- Familiarity with YAML syntax and structure
- Completion of earlier labs (inventory + playbook basics)
- Basic knowledge of package managers:
  - `yum/dnf` for RHEL-based systems
  - `apt` for Debian-based systems
- Understanding of Linux services and `systemd`

---

## 🖥️ Lab Environment
- **Environment Type:** Cloud lab environment (pre-configured nodes)
- **Control Node:** CentOS/RHEL-based (Ansible pre-installed)
- **Managed Nodes:**
  - 1x CentOS/RHEL-based node
  - 1x Ubuntu-based node
- **Connectivity:** SSH pre-configured between nodes
- **Inventory Location:** `/etc/ansible/hosts`
- **Working Directory:** `~/ansible-labs/lab4`

---

## 🗂️ Repository Structure
```text
lab04-introduction-to-ansible-modules/
├── README.md
├── commands.sh
├── output.txt
├── interview_qna.md
├── troubleshooting.md
└── playbooks/
    └── lab4/
        ├── package-management.yml
        ├── apt-management.yml
        ├── universal-packages.yml
        ├── service-management.yml
        ├── advanced-services.yml
        ├── infrastructure-setup.yml
        └── error-handling.yml
````

---

## ✅ Tasks Overview (What I Did)

### ✅ Task 1: Understand Modules + Explore Documentation

* Verified Ansible installation/version (`ansible --version`)
* Listed available modules (`ansible-doc -l`)
* Read module docs to learn options/examples:

  * `ansible-doc yum`
  * `ansible-doc apt`
  * `ansible-doc service`

### ✅ Task 2: Validate Inventory + Connectivity

* Verified inventory groups in `/etc/ansible/hosts`

  * `centos_nodes` and `ubuntu_nodes`
* Confirmed connectivity using `ansible all -m ping`

### ✅ Task 3: Package Management Playbooks (YUM + APT)

* Created playbooks to manage packages on:

  * **CentOS/RHEL nodes** with `yum`
  * **Ubuntu nodes** with `apt`
* Installed single and multiple packages
* Updated packages and cache
* Removed unnecessary or specific packages

### ✅ Task 4: Cross-Platform Package Automation

* Built a universal playbook using `when:` conditions based on `ansible_os_family`
* Installed OS-specific development tool packages per platform

### ✅ Task 5: Service Management (Basic + Advanced)

* Built a cross-platform service playbook:

  * Installs correct web server package (`httpd` vs `apache2`)
  * Starts/enables web service using `service` module
  * Validates status using `register` + `debug`
* Built advanced service operations playbook:

  * SSH service installation and OS-specific service name (`ssh` vs `sshd`)
  * Firewall installation and enablement:

    * `firewalld` on RHEL family
    * `ufw` on Debian family

### ✅ Task 6: Complete Infrastructure Setup Playbook

* Combined modules into one playbook:

  * cache updates + upgrades per OS family
  * common package installation via `package`
  * web packages per OS family
  * enable web server + firewall
  * deploy index page using `copy`
  * restart handler for web service

### ✅ Task 7: Verification + Error Handling

* Verified services using ad-hoc commands (`service` module)

  * observed expected differences in service names (`httpd` vs `apache2`)
* Verified packages installed using `package` module
* Verified HTTP response using `uri` module (HTTP 200)
* Created an error handling playbook:

  * handles missing package installation errors safely
  * handles missing service errors using reliable checks
  * uses retry logic for critical package installation

---

## ✅ Verification & Validation

The following checks confirmed successful lab completion:

* ✅ Inventory was correct and connectivity worked (`ansible all -m ping`)
* ✅ YUM package management playbook ran successfully on RHEL node
* ✅ APT package management playbook ran successfully on Ubuntu node
* ✅ Cross-platform playbook correctly skipped non-applicable tasks (via OS family)
* ✅ Web service installed and started on both nodes (with correct service names)
* ✅ Firewall service installed and started appropriately per OS family
* ✅ Web servers responded with HTTP **200 OK** via `uri`
* ✅ Error-handling logic worked as expected (failures handled gracefully)

---

## 🧠 What I Learned

* Modules are the core “units of work” in Ansible automation
* How to use `ansible-doc` to quickly learn module parameters and examples
* How to pick the correct module per OS (`yum` vs `apt`) and when to use `package`
* How to build cross-platform logic using `ansible_os_family` conditions
* Why service names vary across distributions (`httpd` vs `apache2`, `sshd` vs `ssh`)
* How to verify automation results using ad-hoc Ansible commands
* How to implement basic error handling patterns for reliable playbooks

---

## 🌍 Why This Matters

Modules are what make Ansible automation powerful and scalable. Understanding modules allows you to build reliable infrastructure automation across mixed environments, reduce configuration drift, and standardize deployments across enterprise systems.

---

## 🧩 Real-World Applications

* Automated package baseline installation across server fleets
* Cross-platform automation (RHEL + Ubuntu in one workflow)
* Reliable service enablement for web servers and SSH
* Firewall standardization in mixed environments
* Building reusable automation foundations for larger playbooks and roles

---

## ✅ Result

* Multiple module-based playbooks created and executed
* Cross-platform package + service automation validated
* Error handling patterns implemented and tested
* Verification confirmed services and HTTP responses were working

✅ **Lab completed successfully on a cloud lab environment.**
