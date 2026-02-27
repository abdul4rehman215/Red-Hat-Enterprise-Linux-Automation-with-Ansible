# 🧪 Lab 07: Handlers and Notifications (Ansible)

## 🧾 Lab Summary
This lab focused on **handlers** and **notifications** in Ansible—an essential pattern for safe automation in production. I installed required tools (Ansible + Nginx) on an Ubuntu cloud lab machine, created a playbook that modifies `nginx.conf`, and used `notify` to trigger a handler that restarts Nginx **only when configuration changes occur**. Running the playbook twice demonstrated handler behavior: **first run triggered restart**, second run made no changes so the handler **did not run**.

---

## 🎯 Objectives
By the end of this lab, I was able to:

- Understand what handlers are and why they exist
- Create handlers to restart services after configuration changes
- Use `notify` within tasks to trigger handlers
- Apply handler naming conventions and best practices
- Troubleshoot common handler problems
- Use handlers in realistic service management scenarios

---

## 📌 Prerequisites
Before starting this lab, the following knowledge was required:

- Basic Ansible playbooks and tasks
- YAML syntax fundamentals
- Linux service management (`systemctl`)
- Completion of Labs 1–6
- Basic understanding of web servers (Nginx/Apache)

---

## 🖥️ Lab Environment
- **Environment Type:** Cloud lab environment (Ubuntu)
- **Node Type:** Single Ubuntu machine (localhost managed)
- **User:** `toor`
- **Installed During Lab:** `ansible`, `nginx`
- **Service Managed:** `nginx.service`

> ✅ Note: The lab’s example YAML was provided as a single-line block and required proper formatting (hyphens + indentation) to be valid YAML.

---

## 🗂️ Repository Structure
```text
lab07-handlers-and-notifications/
├── README.md
├── commands.sh
├── output.txt
├── interview_qna.md
├── troubleshooting.md
└── playbooks/
    └── lab7/
        ├── playbook.yml
````

---

## ✅ Tasks Overview (What I Did)

### ✅ Task 1: Create Handlers to Restart Services

* Installed Ansible + Nginx using `apt`
* Created a playbook that updates `worker_processes` in `/etc/nginx/nginx.conf`
* Added a handler to restart nginx whenever that config line changes

### ✅ Task 2: Use `notify` to Call Handlers

* Confirmed that:

  * the handler ran after a changed task
  * the handler did **not** run when the playbook made no changes
* Verified nginx service state using `systemctl status nginx`

---

## ✅ Verification & Validation

The following checks confirmed successful completion:

* ✅ `ansible --version` confirmed Ansible installed successfully
* ✅ First playbook run showed:

  * task changed
  * handler executed
* ✅ Second playbook run showed:

  * task `ok`
  * handler did not run
* ✅ `systemctl status nginx` confirmed nginx is active (running)

---

## 🧠 What I Learned

* Handlers execute **only when notified** by tasks that report `changed`
* Handlers run at the **end of the play** by default
* Repeated notifications still trigger a handler **only once per play**
* Handlers reduce unnecessary restarts and downtime
* `meta: flush_handlers` can be used when an immediate restart is required

---

## 🌍 Why This Matters

In real-world environments, restarting services unnecessarily causes downtime and risk. Handlers ensure services are restarted **only when required**, making automation both **safe** and **efficient**—especially important for production infrastructure.

---

## 🧩 Real-World Applications

* Restarting Nginx/Apache after config changes
* Reloading systemd services after unit file edits
* Restarting databases only when config changes
* Triggering dependent tasks after file/template updates (e.g., reload firewall)

---

## ✅ Result

* Nginx configured via Ansible using `lineinfile`
* Handler correctly restarted nginx only on change
* Service verified to be active and stable

✅ **Lab completed successfully on a cloud lab environment.**
