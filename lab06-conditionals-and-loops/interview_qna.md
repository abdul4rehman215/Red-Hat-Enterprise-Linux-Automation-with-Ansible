# 🧠 Interview Q&A — Lab 06: Conditionals and Loops in Ansible

---

## 1) What is the purpose of `when` in Ansible?
`when` is used to run a task only if a condition evaluates to true. It allows playbooks to behave dynamically depending on facts, variables, host groups, and environment settings.

---

## 2) What kinds of values can be used in `when` conditions?
You can use:
- boolean expressions (`install_web_server == true`)
- comparisons (`ansible_memtotal_mb > 2048`)
- list membership (`item in list`)
- variable existence checks (`var is defined`)
- multiple combined conditions using lists

Example:
```yaml
when:
  - ansible_os_family == "RedHat"
  - environment == "production"
````

---

## 3) Why did the lab use OS-specific tasks for Apache installation?

Because package names and package managers differ:

* RedHat family uses `yum/dnf` and `httpd`
* Debian family uses `apt` and `apache2`

Using facts like `ansible_os_family` ensures the correct module/package is used.

---

## 4) What is a loop in Ansible and why is it useful?

A loop repeats a task over multiple items (like packages, users, directories). It reduces repetition and keeps playbooks clean.

Example:

```yaml
loop:
  - wget
  - curl
  - vim
```

---

## 5) What is the difference between looping over a list and looping over a dictionary?

* Lists provide items directly (`item`)
* Dictionaries require conversion (often using `dict2items`) so you can access `item.key` and `item.value`

Example:

```yaml
loop: "{{ my_dict | dict2items }}"
```

---

## 6) What is `loop_control` used for?

`loop_control` customizes how loops behave, including:

* renaming the loop variable (`loop_var`)
* creating an index variable (`index_var`)
* adding labels for readability

Example:

```yaml
loop_control:
  loop_var: current_item
```

---

## 7) Why did we use `loop_control.index_var`?

To generate numbered/ordered outputs (e.g., directories like `/backup/backup-0`, `/backup/backup-1`) or to reference loop position inside paths/logs.

---

## 8) How were conditionals and loops combined in this lab?

Examples:

* Install role-based package lists using loops + `when`
* Start services only for production using loops + environment condition
* Open firewall ports using loops + OS checks

This creates reusable automation that adapts to role + environment.

---

## 9) Why did Ubuntu fail for `httpd` service in the combined logic playbook?

Ubuntu uses `apache2`, not `httpd`. The playbook role configuration was RedHat-centric, so starting `httpd` on Ubuntu caused “service not found” errors. The playbook continued due to ignore behavior.

---

## 10) What is `service_facts` and why was it used?

`service_facts` collects service state data and stores it under `ansible_facts.services`. It’s useful to validate whether critical services are running before trying to start them.

---

## 11) How did the lab handle starting services safely?

By:

* checking whether service is already running
* starting only required services
* using `ignore_errors: yes` to avoid breaking the run when a service doesn’t exist on a host

---

## 12) Why was `stat` used before backing up files?

To avoid copying missing files. `stat` checks existence, then the backup loop runs only when `item.stat.exists` is true.

---

## 13) What is the difference between skipping and failing in Ansible output?

* **skipping** happens when conditions (`when`) are not met
* **failed** happens when a module cannot perform an action (wrong package, missing service, permission issues)

Skipping is expected behavior in conditional automation.

---

## 14) What is the benefit of role-based data structures like `applications[server_role]`?

It allows one playbook to support multiple server types (web/database/monitoring) without rewriting tasks—only changing the role variable changes package/service/port lists.

---

## 15) What are common mistakes in loops and conditionals?

Common issues include:

* comparing strings to booleans incorrectly (`"true"` vs `true`)
* using wrong service/package names across OS
* forgetting `become: yes` for privileged actions
* not using `dict2items` when iterating dictionaries
* not checking if variables are defined (`var is defined`)

---
