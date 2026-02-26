# 🧠 Interview Q&A — Lab 05: Variables and Facts

---

## 1) What is a variable in Ansible?
A variable is a named value that can be reused throughout a playbook. Variables make playbooks flexible and maintainable by avoiding hardcoding values like ports, package names, or file paths.

---

## 2) What are Ansible facts?
Facts are automatically gathered system details about a managed host (OS, IP, CPU, memory, disks, service manager, etc.). They become available as variables like `ansible_distribution` and `ansible_default_ipv4.address`.

---

## 3) What is the difference between user-defined variables and facts?
- **User-defined variables** are created by the user (e.g., in `vars`, `group_vars`, `host_vars`, `vars_files`, or `set_fact`).
- **Facts** are discovered by Ansible from the target host (e.g., OS, CPU, memory, networking).

---

## 4) Where can variables be defined in Ansible?
Common locations include:
- In playbooks: `vars:`
- In external files: `vars_files:`
- In inventory files (INI/YAML)
- Group variables: `group_vars/`
- Host variables: `host_vars/`
- Dynamically during runs using `set_fact`
- CLI extra vars: `ansible-playbook -e "var=value"`

---

## 5) Why are variables useful in automation?
They reduce duplication and make playbooks reusable. For example, the same playbook can deploy different ports, environments (dev/staging/prod), or packages by changing variable values instead of rewriting tasks.

---

## 6) What does `gather_facts: yes` do?
It tells Ansible to collect system facts from hosts at the start of a play. Facts then become available for conditions, templates, and tasks.

---

## 7) How did this lab use facts for conditional logic?
Facts like `ansible_os_family`, `ansible_distribution_major_version`, and `ansible_processor_cores` were used to run different tasks for different OS families, versions, and hardware capabilities.

---

## 8) What is `set_fact` used for?
`set_fact` creates or overrides variables dynamically during playbook execution. It is useful when values are derived from runtime information (facts, calculations, conditions).

---

## 9) What is variable precedence and why does it matter?
Variable precedence determines which variable value “wins” when the same variable is defined in multiple places (group_vars, host_vars, play vars, set_fact, etc.). Misunderstanding precedence can cause playbooks to behave unexpectedly.

---

## 10) In this lab, how was host-specific configuration applied?
Host-specific variables were placed in:
```text
host_vars/centos1.yml
````

This allowed `centos1` to override playbook-level values like `database_host`.

---

## 11) What are custom facts in Ansible?

Custom facts are additional data you define and store on hosts under:

```text
/etc/ansible/facts.d/
```

They are loaded into `ansible_local.*` and can provide application metadata or health indicators.

---

## 12) How did the lab implement custom facts?

Two custom facts were created:

* `application.fact`: executable script that outputs JSON
* `health.fact`: INI-style file with health metrics

Then facts were refreshed using the `setup` module.

---

## 13) How do you access custom facts in a playbook?

Custom facts appear under:

* `ansible_local.<factfile>.<section/key>`

Example used:

```yaml id="pxxw6n"
ansible_local.application.application.name
```

---

## 14) Why did we avoid using `human_readable` filter in facts output?

Some environments may not have certain filters enabled. To avoid runtime errors while keeping the lab intent, disk sizes were calculated manually in GB using arithmetic operations and `round()`.

---

## 15) How can you safely avoid “variable not defined” errors?

Use the `default` filter:

```yaml id="w0cd4y"
{{ potentially_undefined_var | default('default_value') }}
```

This prevents playbook crashes when variables are missing.

---
