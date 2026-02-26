# 🧠 Interview Q&A — Lab 04: Introduction to Ansible Modules

---

## 1) What is an Ansible module?
An Ansible module is a reusable unit of code that performs a specific action on a target host, such as installing packages, managing files, or controlling services. Modules are the building blocks of tasks inside playbooks.

---

## 2) Why are modules important in automation?
Modules abstract complex system actions into simple YAML syntax. They help ensure:
- consistency
- idempotency (safe re-runs)
- readability and maintainability
- cross-platform support

---

## 3) What is `ansible-doc` and how is it used?
`ansible-doc` is used to view module documentation, including options and examples. Examples:
```bash
ansible-doc yum
ansible-doc apt
ansible-doc service
````

---

## 4) What does `ansible-doc -l` do?

It lists all available modules installed in the Ansible environment. It’s useful to discover what modules exist for automation.

---

## 5) What is idempotency, and why does it matter?

Idempotency means running the same automation multiple times results in the same final system state without causing repeated unnecessary changes. This makes automation predictable and safe.

---

## 6) What is the difference between `yum` and `apt` modules?

* `yum` manages packages on Red Hat-based systems (RHEL/CentOS).
* `apt` manages packages on Debian-based systems (Ubuntu/Debian).

Each module supports package installation, removal, and cache updates, but their parameters differ slightly.

---

## 7) When should you use the `package` module instead of `yum` or `apt`?

Use `package` when you want cross-platform compatibility. It abstracts the OS-specific package manager, making playbooks more portable across different Linux distributions.

---

## 8) How do you write cross-platform tasks for different OS families?

Use facts like `ansible_os_family` with conditionals:

```yaml
when: ansible_os_family == "RedHat"
```

and

```yaml
when: ansible_os_family == "Debian"
```

---

## 9) Why did service verification fail when using `httpd` on Ubuntu?

Because the web server service name differs:

* RHEL/CentOS uses `httpd`
* Ubuntu/Debian uses `apache2`

So attempting `httpd` on Ubuntu results in “service not found.”

---

## 10) What does the `service` module do?

The `service` module manages services by starting, stopping, restarting, reloading, and enabling services at boot. It works across distributions using the system’s init system (often systemd).

---

## 11) What is the purpose of `register` in a task?

`register` stores the output of a task in a variable. This allows later tasks to make decisions, print debug information, or implement logic based on the result.

---

## 12) Why did we use `failed_when: false` in error handling?

Some tasks (like starting a non-existent service) are expected to fail in testing. `failed_when: false` prevents the playbook from stopping and allows us to handle the error gracefully.

---

## 13) What is the purpose of the `uri` module in this lab?

The `uri` module performs HTTP requests to validate web service responses. In this lab it confirmed the web servers returned HTTP `200 OK`.

---

## 14) What are handlers and why are they useful with modules?

Handlers are tasks triggered only when notified by a change. They’re useful for actions like restarting services only when configuration/content changes, preventing unnecessary restarts.

---

## 15) What best practices were applied when using modules?

* using `ansible-doc` to confirm correct parameters
* using `become: yes` for privileged tasks
* using conditionals for OS differences
* verifying results via ad-hoc commands and HTTP checks
* adding error handling to avoid playbook failures in predictable scenarios

---
