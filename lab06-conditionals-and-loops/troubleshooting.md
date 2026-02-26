# 🛠️ Troubleshooting Guide — Lab 06: Conditionals and Loops in Ansible

> This document covers common issues encountered while using `when` conditionals, loops (`loop`), loop filters (`dict2items`), and loop controls (`loop_control`) in Ansible playbooks.

---

## 1) ❌ Tasks always skip (condition never matches)
### ✅ Symptom
Tasks show:
```text
skipping: [host]
````

### 🧩 Causes

* Wrong fact/value used in condition (`ansible_os_family`, OS name mismatch)
* Variable has unexpected type (string vs boolean)
* Condition logic is reversed or too strict

### ✅ Fix

Print the actual fact values:

```yaml id="g2n8p0"
- debug:
    msg: "OS Family={{ ansible_os_family }}, Distribution={{ ansible_distribution }}, Version={{ ansible_distribution_version }}"
```

For booleans, use:

```yaml id="p8c3w1"
when: install_web_server | bool
```

---

## 2) ❌ Comparing string `"true"` to boolean `true`

### ✅ Symptom

Condition does not behave as expected.

### 🧩 Cause

Booleans in YAML are real boolean types, but `"true"` is a string.

### ✅ Fix

Correct boolean checks:

```yaml id="n5m2x3"
when: install_web_server == true
```

Or safe casting:

```yaml id="d0k9r4"
when: install_web_server | bool
```

---

## 3) ❌ Using yum tasks on Ubuntu (or apt on CentOS/RHEL)

### ✅ Symptom

Ubuntu fails on yum tasks OR CentOS fails on apt tasks.

### 🧩 Cause

Package managers differ by OS family.

### ✅ Fix

Use OS checks:

```yaml id="h8v1p7"
when: ansible_os_family == "RedHat"
```

```yaml id="q4m7k1"
when: ansible_os_family == "Debian"
```

For portability, prefer:

```yaml id="w2x9m0"
package:
  name: "{{ item }}"
  state: present
```

---

## 4) ❌ Service names differ across OS (`httpd` vs `apache2`)

### ✅ Symptom

Ubuntu fails:

```text
Could not find the requested service httpd: host
```

### 🧩 Cause

* RedHat uses `httpd`
* Debian/Ubuntu uses `apache2`

### ✅ Fix

Use OS-aware service naming:

```yaml id="k7p1v0"
name: "{{ 'httpd' if ansible_os_family == 'RedHat' else 'apache2' }}"
```

Also apply the same for package names if needed.

---

## 5) ❌ Loop variable confusion (`item` collisions)

### ✅ Symptom

Hard-to-read loops or nested loops break because `item` is reused.

### 🧩 Cause

Default loop variable name is `item`.

### ✅ Fix

Rename loop variable:

```yaml id="n8t2c0"
loop_control:
  loop_var: current_item
```

Then reference:

```yaml id="d5m9r2"
msg: "Processing {{ current_item.name }}"
```

---

## 6) ❌ Iterating dictionaries incorrectly

### ✅ Symptom

Trying to access `.key` or `.value` fails.

### 🧩 Cause

A dictionary does not loop cleanly without conversion.

### ✅ Fix

Use `dict2items`:

```yaml id="p2v8m1"
loop: "{{ database_configs | dict2items }}"
```

Then access:

```yaml id="q0m4x7"
msg: "Database {{ item.key }} runs on {{ item.value.port }}"
```

---

## 7) ❌ index_var misuse in loop_control

### ✅ Symptom

Ansible errors when using index incorrectly.

### 🧩 Cause

`index_var` must be a variable name (like `idx`), not `ansible_loop.index`.

### ✅ Fix

Correct pattern:

```yaml id="k3w7m1"
loop_control:
  index_var: idx
```

---

## 8) ❌ Trying to “pause” inside loop_control

### ✅ Symptom

Playbook fails because `pause` is not valid under `loop_control`.

### 🧩 Cause

`pause` is a separate module, not a loop_control option.

### ✅ Fix

Use a block with `pause`:

```yaml id="m1p8c3"
- block:
    - name: Install package
      package:
        name: "{{ item }}"
        state: present
    - name: Pause after install
      pause:
        seconds: 2
  loop:
    - curl
    - wget
```

---

## 9) ❌ Facts required but not gathered (`package_facts`, `service_facts`)

### ✅ Symptom

Referencing:

```yaml
ansible_facts.packages.firewalld
```

fails because `packages` is missing.

### 🧩 Cause

`package_facts` must run first to populate package data.

### ✅ Fix

Add:

```yaml id="v4n2k8"
- name: Gather installed package facts
  package_facts:
    manager: auto
```

For services:

```yaml id="b8m1p2"
- name: Gather service facts
  service_facts:
```

---

## 10) ❌ Multi-environment deploy errors due to user/group mismatch (`apache` vs `www-data`)

### ✅ Symptom

Ubuntu error:

```text
chown failed: invalid user: 'apache'
```

### 🧩 Cause

Ownership settings are OS-dependent:

* RedHat: `apache`
* Ubuntu: `www-data`

### ✅ Fix

Use conditional owner/group:

```yaml id="z2m7p0"
owner: "{{ 'apache' if ansible_os_family == 'RedHat' else 'www-data' }}"
group: "{{ 'apache' if ansible_os_family == 'RedHat' else 'www-data' }}"
```

---

## 11) ✅ Best practice: verify results with a verification playbook

Verification avoids “it ran but did it work?” problems.

Example checks used in this lab:

* package presence via `package_facts`
* users via `getent`
* directories via `stat`

---
