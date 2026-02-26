
# 🧪 Lab 19: Error Handling and Debugging (Ansible)

## 📌 Lab Summary
This lab focused on **debugging playbooks** and building **resilient automation** by implementing structured error handling patterns in Ansible. I practiced:

- Using `debug` to print variables, facts, and filtered results
- Running playbooks in **dry-run** mode with `--check` (and `--diff`)
- Using `ignore_errors` for non-critical failures
- Implementing robust recovery using `block`, `rescue`, and `always`
- Adding retry logic and generating failure reports/logs for operational visibility

The goal was to gain confidence troubleshooting playbooks and ensuring automation continues safely when parts of a workflow fail.

---

## 🎯 Objectives
By the end of this lab, I was able to:

- Implement `debug` module to output variable values for troubleshooting
- Utilize Ansible's `--check` mode to perform dry runs and validate playbooks
- Implement comprehensive error handling using `ignore_errors` and `block/rescue/always` constructs
- Identify and resolve common Ansible playbook errors
- Apply best practices for debugging and error handling in automation workflows

---

## ✅ Prerequisites
To complete this lab, the following background was required:

- Basic understanding of YAML syntax
- Familiarity with Ansible playbook structure
- Knowledge of Ansible modules and tasks
- Experience running Ansible playbooks
- Understanding of Linux command line basics

---

## 🧰 Lab Environment
**Environment Type:** Cloud lab environment (RHEL/CentOS-based)  
**Control Node:** Ansible installed + configured  
**Managed Nodes:** 2 target nodes (webservers group)  
**Access:** SSH keys + inventory configured

Inventory used:
- `node1` (ansible_host=192.168.1.10)
- `node2` (ansible_host=192.168.1.11)

---

## ✅ What I Performed (Task Overview)

### ✅ Task 1: Using Debug Module to Output Variable Values
- Built a basic debug playbook to print:
  - simple variables
  - formatted messages
  - lists using `var:`
  - system facts (`ansible_distribution`, version)
  - conditional debug output using `when`
- Built an advanced debug playbook to print:
  - loop item details from structured data
  - filtered results (active users only)
  - variable metadata (`type_debug`, length)
  - debug messages controlled by verbosity (`verbosity: 1`)
  - detailed network fact output when available

### ✅ Task 2: Using `--check` Mode for Dry Runs
- Created a playbook that:
  - installs packages
  - creates directories and config files
  - enables a service (with `ignore_errors` for safety)
- Ran it in:
  - `--check` mode to simulate changes safely
  - `--check --diff` to preview file changes
- Built a check-mode-aware playbook using:
  - `ansible_check_mode`
  - conditional task execution to avoid check-mode pitfalls

### ✅ Task 3: Error Handling With `ignore_errors` and `block/rescue/always`
- Demonstrated `ignore_errors` with intentional failures:
  - `/bin/false`
  - installing a non-existent package
  - listing a non-existent directory
- Implemented `block/rescue/always` with:
  - web server deployment + HTTP validation via `uri`
  - fallback to nginx (best-effort) if httpd setup fails
  - always-executed logging and service state reporting
- Implemented nested error handling for database setup:
  - attempt MySQL → rescue to MariaDB → final rescue failure reporting
- Applied best-practice patterns:
  - retry/delay with `until`
  - structured reporting to `/tmp/*-report.txt`
  - defensive service checks and final verification

### ✅ Verification
- Created and executed a dedicated verification playbook to confirm:
  - debug usage
  - check-mode awareness
  - error handling blocks operate correctly
  - final success confirmation output

---

## 🧾 Repository Structure
```text
lab19-error-handling-and-debugging/
├── README.md
├── commands.sh
├── output.txt
├── interview_qna.md
├── troubleshooting.md
├── inventory
├── debug-variables.yml
├── advanced-debug.yml
├── system-changes.yml
├── check-mode-aware.yml
├── basic-error-handling.yml
├── advanced-error-handling.yml
├── error-handling-best-practices.yml
├── error-handling-template.yml
└── verify-lab-completion.yml
````

---

## ✅ Verification & Testing Performed

* `debug-variables.yml` ran successfully on both nodes and printed expected variables/facts.
* `advanced-debug.yml` tested structured loops, filters, and verbosity-level debug output.
* `system-changes.yml` was tested safely using:

  * `--check` to preview intended changes
  * `--check --diff` to preview file diffs
* `check-mode-aware.yml` verified correct behavior in both:

  * check mode
  * normal mode
* `basic-error-handling.yml` validated playbook continuity despite failures using `ignore_errors`.
* `advanced-error-handling.yml` validated:

  * `block/rescue/always` behavior
  * fallback approach + final service status reporting
  * nested rescue logic for database setup
* `error-handling-template.yml` verified:

  * logging to a file
  * success recording + final completion entry
  * log archiving to `/tmp/*.tar.gz`
* `verify-lab-completion.yml` confirmed lab completion output across both nodes.

---

## 🧠 What I Learned

* How to use `debug` effectively (variables, facts, structured data, verbosity-controlled output)
* How to validate playbooks safely using `--check` and `--diff`
* The difference between **non-critical failures** (use `ignore_errors`) vs **critical flows** (use `block/rescue/always`)
* How to build playbooks that:

  * produce useful troubleshooting information
  * fail gracefully
  * generate logs/reports for operations teams
* How to apply retry logic to improve resilience in unstable environments

---

## 🌍 Why This Matters

In real automation environments, failures are unavoidable:

* packages temporarily unavailable
* services not present or misconfigured
* network timeouts
* environment drift across hosts

By building structured error handling and debug visibility into playbooks, automation becomes:

* more reliable
* easier to troubleshoot
* safer to run at scale
* easier to maintain for teams

---

## 🧩 Real-World Applications

* CI/CD pipeline automation where failures must be reported clearly
* production deployments where partial failures should not break everything
* operating at scale across fleets of servers with inconsistent baseline states
* creating reusable playbook patterns and templates for consistent operations

---

## ✅ Result

* ✅ Debug output validated variable scope, facts, and structured loops
* ✅ Check mode previews confirmed changes before applying
* ✅ Failures handled gracefully using `ignore_errors`
* ✅ Recovery paths implemented using `block/rescue/always`
* ✅ Verification playbook confirmed successful completion across all targets

---

## 🏁 Conclusion

This lab strengthened my ability to write Ansible automation that is **observable, resilient, and production-friendly**. I can now debug faster, predict changes safely with check mode, and design playbooks that recover cleanly from failures while generating actionable logs and reports.
