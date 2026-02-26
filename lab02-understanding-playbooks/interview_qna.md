# 🧠 Interview Q&A — Lab 02: Understanding Playbooks

---

## 1) What is an Ansible playbook?
An Ansible playbook is a **YAML file** that defines automation steps (plays and tasks) to run against one or more target hosts. It describes the desired state of systems and the actions needed to reach that state.

---

## 2) What are the main sections of a playbook?
Common sections include:
- `name` (description of play)
- `hosts` (inventory group or hosts to target)
- `become` (privilege escalation)
- `gather_facts` (collect system information)
- `vars` / `vars_files` (variables)
- `pre_tasks`, `tasks`, `post_tasks`
- `handlers` (triggered by notify)

---

## 3) Why is YAML indentation important in Ansible playbooks?
YAML is indentation-sensitive. Incorrect indentation can break the structure of a playbook and cause parsing failures. Lists must be properly aligned and use `-` list markers.

---

## 4) What is the purpose of `hosts: managed_nodes` in a playbook?
It targets the play to the `managed_nodes` group in the inventory. Ansible will run all tasks in that play on every host within that group.

---

## 5) What does `become: yes` do?
It enables privilege escalation (similar to `sudo`) so tasks can perform administrative actions such as installing packages, modifying system files, or managing services.

---

## 6) What are handlers in Ansible, and why are they used?
Handlers are tasks that run **only when notified** by another task that changed something. They’re commonly used for service restarts or reloads to avoid unnecessary restarts.

---

## 7) What does `notify` do in a task?
`notify` triggers one or more handlers if the task results in a change. If the task makes no changes, the handler is not triggered.

---

## 8) What is the difference between running a playbook normally and using `--check` mode?
- Normal run: applies changes to the systems.
- `--check` mode: performs a **dry run** to show what would change without actually applying it (useful for safe previews).

---

## 9) What does `ansible-playbook --syntax-check` validate?
It checks the playbook YAML structure and Ansible syntax without executing tasks. If it outputs the playbook name only, the syntax is valid.

---

## 10) What is `ansible-inventory --list` used for?
It verifies that Ansible can parse the inventory and shows:
- groups
- hosts
- host variables
- group variables

This helps validate targeting and variable definitions.

---

## 11) What are facts in Ansible and how were they used in this lab?
Facts are system details collected from managed nodes (OS, IP, memory, CPU, etc.). In this lab, facts were gathered via:
- `gather_facts: yes`
- `ansible -m setup --tree /tmp/facts`

Facts were also used in the template to generate dynamic web content.

---

## 12) Why use Jinja2 templates (`.j2`) instead of static files?
Templates allow dynamic content generation using variables and facts (e.g., hostname, IP, OS). This enables personalized configs/pages per host and supports scalable automation.

---

## 13) What are tags in Ansible and why are they useful?
Tags let you run specific parts of a playbook without executing everything. Example:
- `--tags "packages,firewall"`
This is useful for fast targeted changes and faster debugging.

---

## 14) What is `block/rescue/always` used for?
It provides structured error handling:
- `block`: tasks that might fail
- `rescue`: tasks that run if the block fails
- `always`: tasks that always run (cleanup/logging)

This is useful for reliable automation in production.

---

## 15) How can you verify results after running a playbook?
Verification can be done using:
- ad-hoc commands (service/file/shell modules)
- `curl` to confirm web response codes
- verification playbooks (like `verify-setup.yml`)
- check file permissions/ownership and service status

---
