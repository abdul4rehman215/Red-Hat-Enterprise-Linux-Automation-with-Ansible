# 🧪 Lab 01: Introduction to Ansible

## 🧾 Lab Summary
This lab sets up the **Ansible control node** on a Linux cloud lab environment and verifies that Ansible can successfully execute modules against a managed host using a basic inventory and the **ping** module.

---

## 🎯 Objectives
By the end of this lab, I was able to:

- Understand what Ansible is and its core components (control node, managed nodes, inventory, modules)
- Install Ansible on a control node using a package manager
- Create and configure a basic inventory file
- Verify successful communication with a managed host using the **ping** module

---

## 📌 Prerequisites
Before starting this lab, the following knowledge was required:

- Basic Linux command line operations
- Familiarity with SSH concepts and key-based authentication
- Knowledge of text editors like **nano** or **vim**
- Understanding of YAML syntax basics

---

## 🖥️ Lab Environment
- **Platform:** Cloud lab environment (bare-metal Linux machine)
- **OS:** Ubuntu (noble)
- **Role:** Single machine used as **Control Node** and **Managed Host** (localhost)

---

## 🗂️ Repository Structure
```text
lab01-introduction-to-ansible/
├── README.md
├── commands.sh
├── output.txt
├── interview_qna.md
└── troubleshooting.md
````

---

## ✅ Tasks Overview (What I Did)

### ✅ Task 1: Install Ansible on the Control Node

* Updated package index
* Installed Ansible using `apt`
* Confirmed installation using `ansible --version`

### ✅ Task 2: Set Up a Basic Inventory

* Edited the default inventory file: `/etc/ansible/hosts`
* Added a **local group** and configured `localhost` to run without SSH using `ansible_connection=local`
* Verified inventory contents with `cat`

### ✅ Task 3: Run a Simple Ping Command

* Executed Ansible `ping` module against the `local` group
* Confirmed successful module execution via `"ping": "pong"`

---

## ✅ Verification & Validation

* Verified Ansible installation:

  * `ansible --version` ✅
* Verified inventory configuration:

  * `/etc/ansible/hosts` contains correct group and host ✅
* Verified Ansible connectivity/module execution:

  * `ansible local -m ping` returns `"pong"` ✅

---

## 🧠 What I Learned

* How Ansible inventories define target systems and groups
* How to configure local execution using `ansible_connection=local`
* That Ansible’s `ping` module validates module execution (not ICMP)
* The Ansible control node environment is the base for all automation going forward

---

## 🌍 Why This Matters

This lab builds the foundation required for **enterprise automation** using Ansible. With Ansible installed and validated, it becomes possible to manage and automate tasks across many servers consistently—critical for sysadmin, DevOps, and security operations.

---

## 🧩 Real-World Applications

* Automating package installation and OS configuration across fleets
* Validating connectivity and interpreter availability across managed nodes
* Preparing for more advanced automation using playbooks, roles, and inventories in production environments

---

## ✅ Result

* Ansible installed successfully
* Inventory configured correctly
* Managed host communication validated via `ping` module

✅ **Lab completed successfully on a cloud lab environment.**
