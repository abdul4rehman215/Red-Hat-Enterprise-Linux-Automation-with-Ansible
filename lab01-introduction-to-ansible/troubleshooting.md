# 🛠️ Troubleshooting Guide — Lab 01: Introduction to Ansible

> This document contains common issues that may occur while installing Ansible, configuring inventory, and validating connectivity with the `ping` module.

---

## 1) ❌ `ansible: command not found`
### ✅ Symptom
Running:
```bash
ansible --version
````

returns:

```text
ansible: command not found
```

### 🧩 Cause

Ansible is not installed, or installation failed.

### ✅ Fix

Update package index and install Ansible:

```bash
sudo apt update
sudo apt install ansible -y
```

Verify again:

```bash
ansible --version
```

---

## 2) ❌ `E: Unable to locate package ansible`

### ✅ Symptom

Running:

```bash
sudo apt install ansible -y
```

returns:

```text
E: Unable to locate package ansible
```

### 🧩 Cause

* Package lists are outdated
* `universe` repository may be disabled (Ubuntu-based systems)

### ✅ Fix

Update package lists:

```bash
sudo apt update
```

Enable universe repository (if required):

```bash
sudo add-apt-repository universe
sudo apt update
sudo apt install ansible -y
```

---

## 3) ❌ Permission denied when editing `/etc/ansible/hosts`

### ✅ Symptom

Trying to edit the inventory file:

```bash
nano /etc/ansible/hosts
```

fails with permission errors.

### 🧩 Cause

The inventory is under `/etc/ansible/`, which requires root privileges.

### ✅ Fix

Use `sudo`:

```bash
sudo nano /etc/ansible/hosts
```

---

## 4) ❌ Inventory group not found / “No hosts matched”

### ✅ Symptom

Running:

```bash
ansible local -m ping
```

returns:

```text
[WARNING]: Could not match supplied host pattern, ignoring: local
ERROR! Specified hosts and/or --limit does not match any hosts
```

### 🧩 Cause

The inventory group `[local]` may not exist, or inventory file is incorrect.

### ✅ Fix

Confirm inventory file contents:

```bash
sudo cat /etc/ansible/hosts
```

It should contain:

```ini
[local]
localhost ansible_connection=local
```

---

## 5) ❌ Ping fails because Python is missing (common on minimal images)

### ✅ Symptom

Running:

```bash
ansible local -m ping
```

returns a Python-related error.

### 🧩 Cause

Some minimal Linux images may not include Python by default.

### ✅ Fix

Install Python 3:

```bash
sudo apt update
sudo apt install python3 -y
```

Confirm:

```bash
python3 --version
```

Then re-run:

```bash
ansible local -m ping
```

---

## 6) ❌ `sudo: unable to resolve host ...`

### ✅ Symptom

Any sudo command outputs:

```text
sudo: unable to resolve host <hostname>
```

### 🧩 Cause

Hostname mismatch between `/etc/hostname` and `/etc/hosts`.

### ✅ Fix

Check hostname:

```bash
cat /etc/hostname
```

Check `/etc/hosts`:

```bash
cat /etc/hosts
```

Ensure hostname appears correctly in `/etc/hosts`, then retry sudo.

---

✅ If none of the fixes apply, validate:

* Ansible installation: `ansible --version`
* Inventory correctness: `sudo cat /etc/ansible/hosts`
* Module execution: `ansible local -m ping`
