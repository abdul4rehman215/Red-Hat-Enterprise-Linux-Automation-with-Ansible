# 🛠️ Troubleshooting Guide — Lab 03: Managing Inventory

> This document covers common issues when working with static inventories (INI/YAML), dynamic inventories (scripts), grouping, variable assignment, and connectivity validation.

---

## 1) ❌ SSH “Authenticity of host can't be established” prompt
### ✅ Symptom
First SSH login shows:
```text
The authenticity of host 'ansible-control (192.168.1.5)' can't be established.
Are you sure you want to continue connecting (yes/no)?
````

### 🧩 Cause

SSH is seeing the host key for the first time and asks to trust it.

### ✅ Fix

Type:

```text
yes
```

Then continue. This adds the host to `~/.ssh/known_hosts`.

---

## 2) ❌ SSH authentication failure (password / key issues)

### ✅ Symptom

Ansible ping fails or SSH fails with:

```text
Permission denied (publickey,password).
```

### 🧩 Cause

* SSH key not present or incorrect
* Wrong user in inventory (`ansible_user`)
* SSH key not copied to managed nodes
* Key permissions too open

### ✅ Fix

Generate a key if missing:

```bash id="p6u2gx"
ssh-keygen -t rsa -b 2048 -f ~/.ssh/id_rsa
```

Copy key to a managed node:

```bash id="v7st90"
ssh-copy-id student@192.168.1.10
```

Fix permissions:

```bash id="b0qtr2"
chmod 700 ~/.ssh
chmod 600 ~/.ssh/id_rsa
chmod 644 ~/.ssh/id_rsa.pub
```

Re-test:

```bash id="1j5s0w"
ansible all -i inventory.ini -m ping
```

---

## 3) ❌ Inventory group not found / “No hosts matched”

### ✅ Symptom

Running:

```bash id="u6k3qy"
ansible webservers -i inventory.ini -m ping
```

returns:

```text
Could not match supplied host pattern
```

### 🧩 Cause

* Group name typed incorrectly
* Inventory file not being used (`-i` missing or wrong path)

### ✅ Fix

Check inventory group headings:

```bash id="u9z5b9"
cat inventory.ini
```

List parsed inventory:

```bash id="xw5r8y"
ansible-inventory -i inventory.ini --list
```

---

## 4) ❌ INI inventory syntax issues

### ✅ Symptom

Inventory parsing fails or groups/vars missing unexpectedly.

### 🧩 Cause

* Missing brackets on group headers `[group]`
* Variables formatted incorrectly
* Comments placed in wrong places
* Copy-paste mistakes

### ✅ Fix

Use:

```bash id="tq9r8j"
ansible-inventory -i inventory.ini --list --yaml
```

This shows if Ansible correctly parsed the INI structure.

---

## 5) ❌ YAML inventory indentation errors

### ✅ Symptom

Running:

```bash id="mkrh92"
ansible all -i inventory.yml -m ping
```

fails with YAML parsing errors.

### 🧩 Cause

YAML is indentation-sensitive. A single space mistake can break the structure.

### ✅ Fix

Validate with:

```bash id="dkf0d2"
ansible-inventory -i inventory.yml --list
```

If needed, print partial file and confirm indentation:

```bash id="wshv52"
sed -n '1,80p' inventory.yml
```

---

## 6) ❌ Dynamic inventory script not executable

### ✅ Symptom

Running:

```bash id="xq8p2p"
ansible all -i ./dynamic-inventory.py -m ping
```

fails with:

```text
Permission denied
```

### 🧩 Cause

Script does not have execute permission.

### ✅ Fix

Make it executable:

```bash id="d7p8vv"
chmod +x dynamic-inventory.py
```

---

## 7) ❌ Dynamic inventory script returns invalid JSON

### ✅ Symptom

`ansible-inventory` fails or shows JSON parse errors.

### 🧩 Cause

* Script prints extra text (debug messages)
* JSON is malformed
* Incorrect quoting / missing braces
* Indentation is fine, but output is not JSON

### ✅ Fix

Run manually:

```bash id="ax1y0a"
./dynamic-inventory.py --list
```

Output must be valid JSON only.

If debugging is needed, print debug logs to stderr (not stdout).

---

## 8) ❌ Host variables missing in dynamic inventory

### ✅ Symptom

`--host web1` returns empty or Ansible doesn’t see `ansible_host`.

### 🧩 Cause

`_meta.hostvars` missing or incorrect host key mapping.

### ✅ Fix

Ensure inventory includes:

```json
"_meta": { "hostvars": { ... } }
```

Test host vars directly:

```bash id="p2bbp7"
./dynamic-inventory.py --host web1
```

---

## 9) ❌ Slow inventory parsing (large environments)

### ✅ Symptom

Ansible inventory commands take too long.

### 🧩 Cause

* Large inventory files
* Dynamic scripts doing heavy discovery without caching

### ✅ Fix

Measure performance:

```bash id="f7x4xk"
time ansible-inventory -i inventory.ini --list > /dev/null
time ansible-inventory -i ./dynamic-inventory.py --list > /dev/null
```

Use caching in dynamic scripts if needed, and limit target hosts:

```bash id="9r0v6g"
ansible all -i inventory.ini --limit web1 -m ping
```

---

## 10) ✅ Best troubleshooting command: `-vvv`

### ✅ When to use

For detailed SSH troubleshooting and inventory parsing behavior.

### ✅ Command

```bash id="g0hh2m"
ansible all -i inventory.ini -m ping -vvv
```

This shows:

* which inventory plugin parsed the file
* SSH command being executed
* connection attempts and results

---
