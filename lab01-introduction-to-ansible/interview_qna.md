# 🧠 Interview Q&A — Lab 01: Introduction to Ansible

---

## 1) What is Ansible and why is it used?
Ansible is an **agentless automation tool** used for configuration management, application deployment, and orchestration. It uses **SSH (or local connection)** to run tasks on managed hosts, making it lightweight and easy to adopt in enterprise environments.

---

## 2) What are the core components of Ansible?
Key components include:
- **Control Node:** The machine where Ansible is installed and run from
- **Managed Nodes:** Target machines that Ansible manages
- **Inventory:** A file (or dynamic source) listing managed hosts and groups
- **Modules:** Reusable units of work (e.g., `ping`, `apt`, `copy`)
- **Playbooks:** YAML files that define automation tasks and workflows

---

## 3) What does “agentless” mean in Ansible?
Agentless means Ansible **does not require installing an agent** on managed hosts. It typically connects using SSH (or local execution) and runs tasks using built-in modules.

---

## 4) What is an Ansible inventory file used for?
The inventory file defines:
- Which hosts Ansible can manage
- How those hosts are grouped (e.g., `[web]`, `[db]`)
- Connection variables (e.g., SSH user, ports, connection type)

---

## 5) Why did we configure `localhost ansible_connection=local`?
This tells Ansible to manage `localhost` **without using SSH**. Instead, it executes tasks directly on the local machine. This is useful for testing and for automating tasks on the control node itself.

---

## 6) Is Ansible “ping” the same as Linux ICMP ping?
No. The Ansible `ping` module **does not send ICMP packets**. It checks whether Ansible can:
- connect to the target host (local/SSH)
- run Python
- execute modules successfully  
The `"pong"` response confirms success.

---

## 7) What does the output `"ping": "pong"` confirm?
It confirms:
- inventory host/group targeting is correct
- Ansible can execute a module successfully
- Python interpreter is available and discovered
- basic Ansible setup is working

---

## 8) Why is Python important for Ansible?
Most Ansible modules rely on Python on the managed host to execute tasks. Ansible detects the interpreter (e.g., `/usr/bin/python3`) and uses it to run module code.

---

## 9) Where is the default Ansible configuration file located (as shown in output)?
In this lab output, it shows:
- `/etc/ansible/ansible.cfg`

This file can define default inventory paths, privilege escalation settings, module paths, and more.

---

## 10) What are Ansible modules?
Modules are pre-built tools used to perform tasks such as:
- package installation (`apt`, `dnf`)
- file management (`copy`, `file`)
- user management (`user`)
- service management (`systemd`)
- testing connectivity (`ping`)

---

## 11) What is the difference between a module and a playbook?
- **Module:** A single action (example: install package, copy file)
- **Playbook:** A YAML file that runs **multiple tasks/modules** in sequence to automate a workflow

---

## 12) Why is this lab important for Ansible automation going forward?
Because it establishes the foundation:
- Ansible is installed
- inventory is configured
- connectivity is verified

Without these basics, playbooks, roles, and advanced automation workflows won’t run reliably.

---

## 13) What is the typical next step after verifying ping connectivity?
Common next steps include:
- writing a simple playbook (YAML)
- using variables and facts
- managing packages and files using modules
- expanding inventory to include multiple managed hosts

---

## 14) In enterprise environments, what can Ansible manage at scale?
Ansible can automate tasks such as:
- OS hardening and baseline configuration
- patching and updates
- app deployments
- user and permission management
- service configuration
- multi-tier orchestration (web + database + load balancer)

---
