# 🎤 Interview Q&A — Lab 19: Error Handling and Debugging (Ansible)

## 1) Why is the `debug` module important in Ansible?
**Answer:**  
It helps troubleshoot playbooks by printing variable values, loop items, facts, and task context. It’s one of the fastest ways to understand what Ansible “knows” at runtime.

---

## 2) What is the difference between `debug: msg:` and `debug: var:`?
**Answer:**  
- `debug: msg:` prints a custom message (can include templating like `{{ var }}`).
- `debug: var:` prints the full value of a variable (often formatted as JSON-like output).

---

## 3) How do you debug host facts in Ansible?
**Answer:**  
Facts are collected with `gather_facts: yes`. You can print them using:
```yaml id="1v9lhn"
- debug:
    var: ansible_distribution
````

Or show multiple facts using `msg`.

---

## 4) What does `--check` mode do?

**Answer:**
`--check` runs a playbook in **dry-run** mode. It simulates changes without applying them, helping validate logic safely before real execution.

---

## 5) What does `--diff` add when used with `--check`?

**Answer:**
`--diff` shows what would change in files/templates (before vs after). It’s especially helpful for config management and reviewing modifications.

---

## 6) What is `ansible_check_mode` and how did we use it?

**Answer:**
`ansible_check_mode` is a boolean that is `true` when playbook runs in check mode. We used it to display messages and to handle tasks differently during dry runs:

```yaml id="f9bbcl"
when: ansible_check_mode
```

---

## 7) What is `ignore_errors` used for?

**Answer:**
It allows playbook execution to continue even when a task fails. It’s useful for non-critical tasks where failure should not stop the whole workflow.

---

## 8) What’s a risk of using `ignore_errors` everywhere?

**Answer:**
It can hide critical failures and cause later tasks to run on a broken system, resulting in inconsistent or unsafe automation outcomes. It should be used only for non-critical steps with proper reporting.

---

## 9) What is the purpose of `block/rescue/always`?

**Answer:**
It provides structured try/catch/finally behavior:

* `block`: main tasks
* `rescue`: recovery steps if something fails
* `always`: tasks that must run no matter what (cleanup/logging)

---

## 10) Why did we use `rescue` to install an alternative web server?

**Answer:**
To demonstrate fallback behavior. If `httpd` setup fails, the playbook attempts `nginx` to keep service available and reduce downtime.

---

## 11) How does nested error handling help?

**Answer:**
Nested blocks allow granular recovery. In the lab:

* Primary attempt: install MySQL
* Rescue: fallback to MariaDB
  If both fail, the outer rescue handles total failure reporting.

---

## 12) What is the purpose of `changed_when: false`?

**Answer:**
It prevents Ansible from reporting “changed” for tasks that are checks or validations (like `systemctl is-active`). This makes output cleaner and more accurate.

---

## 13) Why is creating failure reports useful in automation?

**Answer:**
Reports provide operational visibility and help incident response. Instead of just failing silently, automation can output actionable diagnostics like timestamps, hostnames, and error context.

---

## 14) How do retries and `until` improve reliability?

**Answer:**
They handle transient failures (repo issues, network glitches, temporary locks). Example:

* retry package cache update up to 3 times
* proceed only when the result succeeds

---

## 15) What best practice did this lab demonstrate for production playbooks?

**Answer:**
Use a layered approach:

* `debug` for visibility
* `--check --diff` before applying changes
* `ignore_errors` only where safe
* `block/rescue/always` for critical workflows
* logging + reporting for maintainability
