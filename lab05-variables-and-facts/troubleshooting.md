# 🛠️ Troubleshooting Guide — Lab 05: Variables and Facts

> This document covers common problems when working with Ansible variables, facts, host/group variable files, custom facts, and conditional logic.

---

## 1) ❌ "VARIABLE IS NOT DEFINED!" / undefined variable errors
### ✅ Symptom
Playbook fails with errors like:
```text id="s0x5q1"
The task includes an option with an undefined variable.
````

### 🧩 Cause

* Variable is misspelled
* Variable exists only for some hosts
* Variable file not loading (wrong path or naming)
* Using a variable before it is created (`set_fact` runs later)

### ✅ Fix

Use safe defaults:

```yaml id="j1m5z8"
msg: "Value: {{ maybe_missing_var | default('default_value') }}"
```

Verify variable presence for a host:

```bash id="p9c3r2"
ansible-inventory -i inventory --host centos1
```

---

## 2) ❌ Facts not available in playbook tasks

### ✅ Symptom

Facts like `ansible_distribution` or `ansible_default_ipv4.address` appear undefined.

### 🧩 Cause

Facts were not gathered (rare, but possible if `gather_facts: no` is set).

### ✅ Fix

Ensure the play includes:

```yaml id="x8t2m7"
gather_facts: yes
```

Or gather facts manually using `setup`:

```yaml id="f4q1w9"
- name: Refresh facts
  setup:
```

---

## 3) ❌ YAML parsing errors (indentation problems)

### ✅ Symptom

Errors such as:

* `mapping values are not allowed in this context`
* `did not find expected '-' indicator`

### 🧩 Cause

YAML indentation mistakes (spaces vs tabs, wrong nesting).

### ✅ Fix

Run syntax check:

```bash id="t8c4m1"
ansible-playbook -i inventory --syntax-check playbook.yml
```

Use consistent indentation (2 spaces recommended).

---

## 4) ❌ group_vars or host_vars not loading

### ✅ Symptom

Variables in `group_vars/all.yml` or `host_vars/<host>.yml` are not applied.

### 🧩 Cause

* Wrong folder names (must be exactly `group_vars` / `host_vars`)
* Wrong filenames (host_vars must match inventory hostname)
* Directory placed at wrong level relative to playbook execution path

### ✅ Fix

Confirm structure:

```text id="x9v2k0"
./group_vars/all.yml
./host_vars/centos1.yml
```

Confirm the hostname matches inventory:

```bash id="p7m1w3"
ansible all -i inventory --list-hosts
```

---

## 5) ❌ Custom facts not appearing under `ansible_local`

### ✅ Symptom

`ansible_local.*` is empty or missing your fact keys.

### 🧩 Cause

* Facts directory missing or wrong permissions
* `.fact` file not executable (for script facts)
* Incorrect file format (script must output valid JSON)
* Facts not refreshed after creation

### ✅ Fix

Ensure directory exists:

```bash id="v3m7k2"
ls -la /etc/ansible/facts.d
```

If it’s a script-based `.fact`, ensure executable:

```bash id="m5p0q8"
chmod 755 /etc/ansible/facts.d/application.fact
```

Refresh facts:

```yaml id="b2w9n1"
- name: Refresh facts
  setup:
```

---

## 6) ❌ Wrong custom fact path when referencing values

### ✅ Symptom

You see undefined errors when referencing:

```yaml
ansible_local.application.name
```

(or similar)

### 🧩 Cause

Custom fact structure depends on JSON/INI structure. In this lab, JSON returned:

```json
{ "application": { ... } }
```

So the correct path becomes:

```yaml id="f2c8m0"
ansible_local.application.application.<key>
```

### ✅ Fix

Print the full custom fact structure:

```yaml id="k8v1p6"
- debug:
    var: ansible_local
```

Then adjust references accordingly.

---

## 7) ❌ Conditional tasks not running (unexpected skipping)

### ✅ Symptom

Tasks show `skipping:` even when expected to run.

### 🧩 Cause

`when:` conditions don’t match the actual facts (e.g., OS family values).

### ✅ Fix

Print the facts used in condition:

```yaml id="s2k9m3"
- debug:
    msg: "OS Family: {{ ansible_os_family }}, Version: {{ ansible_distribution_major_version }}"
```

Common values:

* `ansible_os_family`: `RedHat`, `Debian`
* `ansible_distribution`: `CentOS`, `Ubuntu`

---

## 8) ❌ Type conversion issues (strings vs numbers)

### ✅ Symptom

Numeric comparisons fail or math behaves incorrectly.

### 🧩 Cause

Variables sometimes come as strings.

### ✅ Fix

Convert using filters:

```yaml id="k4m9p3"
when: (ansible_distribution_major_version | int) < 8
```

Or for arithmetic:

```yaml id="c9w2m8"
memory_gb: "{{ (ansible_memtotal_mb | float / 1024) | round(1) }}"
```

---

## 9) ❌ `human_readable` filter not found

### ✅ Symptom

Playbook fails using `| human_readable`.

### 🧩 Cause

Filter might not exist/enabled in certain environments.

### ✅ Fix

Use manual conversion like in the lab:

```yaml id="m7p2x0"
Size (GB): {{ (item.size_total / 1024 / 1024 / 1024) | round(2) }}
```

---

## 10) ✅ Best practice: verify with assertions (`assert`)

### ✅ Why it helps

Assertions provide automated validation that variables and facts exist and conditions are met.

### ✅ Example

```yaml id="q1v0m4"
- assert:
    that:
      - ansible_hostname is defined
      - ansible_distribution is defined
```

---
