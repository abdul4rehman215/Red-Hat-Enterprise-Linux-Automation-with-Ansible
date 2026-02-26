# 🛠️ Troubleshooting Guide — Lab 19: Error Handling and Debugging (Ansible)

> This guide lists common playbook errors and debugging steps used in this lab.

---

## 1) ❌ Variables Not Showing Expected Values in `debug`

### ✅ Symptoms
- Debug prints empty/undefined values
- Messages show `VARIABLE IS NOT DEFINED!`

### 🔍 Likely Causes
- Variable not defined in correct scope (`vars`, `vars_files`, inventory/group_vars/host_vars)
- Typo in variable name
- Variable defined after the debug task

### ✅ Fix
1. Confirm variable spelling in playbook.
2. Print variable safely:
```yaml id="m8t2pn"
- debug:
    var: app_name
````

3. Check scope:

* `vars:` only applies inside that play
* inventory variables apply per host/group
* `set_fact` applies to the current host

---

## 2) ❌ Debug Message Not Appearing (Verbosity-Controlled Debug)

### ✅ Symptoms

* Task `Debug with verbosity levels` is skipped without `-v`

### 🔍 Cause

* `verbosity: 1` means it only prints at `-v` or higher.

### ✅ Fix

Run playbook with verbosity:

```bash id="o8m1o0"
ansible-playbook -i inventory advanced-debug.yml -v
```

---

## 3) ❌ Check Mode Shows `changed` But Nothing Actually Happened

### ✅ Symptoms

* `--check` output shows `changed: [node1]` for file/directory creation

### 🔍 Explanation

In check mode, Ansible reports **what would change**. Some modules report changes without creating anything.

### ✅ Fix

Use `--diff` to preview file differences:

```bash id="vcm2qx"
ansible-playbook -i inventory system-changes.yml --check --diff
```

---

## 4) ❌ Tasks Fail in Check Mode But Work in Normal Mode

### ✅ Symptoms

* Check mode play fails on tasks that require real changes
* Example: service start or command output validation

### 🔍 Likely Causes

* Some modules/actions are not fully check-mode friendly
* Dependent resources do not exist yet in check mode

### ✅ Fix

Guard tasks with:

```yaml id="1m9d7w"
when: not ansible_check_mode
```

Or add check-mode messages:

```yaml id="v6cmg4"
when: ansible_check_mode
```

---

## 5) ❌ Playbook Stops Even Though `ignore_errors: yes` Was Intended

### ✅ Symptoms

* A task failure halts execution unexpectedly

### 🔍 Likely Causes

* `ignore_errors` placed at wrong indentation level
* Failure occurs in a different task than expected (not the ignored task)

### ✅ Fix

Ensure indentation and placement is correct:

```yaml id="pvdn0u"
- name: Non-critical task
  command: /bin/false
  ignore_errors: yes
```

---

## 6) ❌ Using `ignore_errors` Causes Hidden Failures Later

### ✅ Symptoms

* Playbook continues, but later tasks behave incorrectly
* Variables or services expected to exist are missing

### 🔍 Cause

* Ignoring failures without logging them hides important signals

### ✅ Fix

Register output and log failures:

```yaml id="vqa7a7"
- name: Risky task
  command: /bin/false
  register: result
  ignore_errors: yes

- debug:
    msg: "Task failed with rc={{ result.rc }}"
```

---

## 7) ❌ `block/rescue/always` Not Working as Expected

### ✅ Symptoms

* Rescue doesn’t run
* Always doesn’t run
* YAML parser errors

### 🔍 Likely Causes

* Bad indentation or invalid YAML structure
* Rescue is not at same level as block

### ✅ Fix

Ensure structure:

```yaml id="yp9y5h"
- block:
    - name: Main task
      ...
  rescue:
    - name: Recovery
      ...
  always:
    - name: Cleanup
      ...
```

---

## 8) ❌ `uri` Test Fails Even Though Service Is Running

### ✅ Symptoms

* `uri` returns non-200 status or times out
* Happens when testing from control node

### 🔍 Likely Causes

* Wrong URL/hostname resolution
* Firewall blocks HTTP
* Service not bound/listening where expected

### ✅ Fix

1. Use host IP from inventory:

```yaml id="xyqk7n"
url: "http://{{ ansible_host | default(inventory_hostname) }}"
```

2. Verify service:

```bash id="w39f7j"
ansible webservers -i inventory -m shell -a "systemctl status httpd && ss -tulpen | grep :80" --become
```

3. Verify firewall (if applicable):

```bash id="4uqx4p"
ansible webservers -i inventory -m shell -a "firewall-cmd --list-all" --become
```

---

## 9) ❌ Database Package Not Available (`mysql-server` missing)

### ✅ Symptoms

* Task fails:

  * `No package mysql-server available.`

### 🔍 Likely Causes

* Repo does not provide `mysql-server` package on this OS/version
* MySQL packages may require external repos
* MariaDB is the default on many RHEL/CentOS images

### ✅ Fix

Use fallback to MariaDB (as in lab rescue):

```yaml id="fe1xi6"
- name: Install MariaDB
  yum:
    name: mariadb-server
    state: present
```

---

## 10) ✅ Best Debugging Commands (Practical)

### Run with verbosity

```bash id="t7u63b"
ansible-playbook -i inventory playbook.yml -v
```

### Increase verbosity further

```bash id="u7x4s0"
ansible-playbook -i inventory playbook.yml -vvv
```

### Confirm inventory connectivity

```bash id="dsr2g7"
ansible webservers -i inventory -m ping
```

### Print full facts for a host

```bash id="zv7ps9"
ansible node1 -i inventory -m setup
```

---

## 11) ✅ Validation Approach Used in This Lab

The verification playbook confirmed:

* debug module usage
* check mode awareness
* error handling block behavior
* always block runs correctly

Run verification:

```bash id="zjmq7h"
ansible-playbook -i inventory verify-lab-completion.yml
```
