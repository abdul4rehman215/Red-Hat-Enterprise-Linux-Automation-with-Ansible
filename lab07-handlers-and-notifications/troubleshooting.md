# 🛠️ Troubleshooting Guide — Lab 07: Handlers and Notifications

> This document covers common issues when working with `handlers` and `notify` in Ansible, especially when managing services like Nginx.

---

## 1) ❌ Handler did not run (but you expected it to)
### ✅ Symptom
You run the playbook and only see the task output, but no:
```text
RUNNING HANDLER [...]
````

### 🧩 Common Causes

* The task did **not** produce `changed`
* The handler name in `notify` does not match the handler name
* The handler is defined in the wrong section (indentation or placement issues)

### ✅ Fix

Confirm the task actually changed something:

* If it says `ok`, it did not change, so handler will not run.

Check handler name matches exactly:

```yaml
notify: restart nginx
...
handlers:
  - name: restart nginx
```

---

## 2) ❌ Notify name mismatch

### ✅ Symptom

Playbook runs but handler never triggers.

### 🧩 Cause

`notify` refers to a handler name that does not exist.

### ✅ Fix

Ensure spelling matches exactly (case-sensitive):

```yaml id="s5n0p2"
notify: restart nginx
```

```yaml id="t2v7m1"
- name: restart nginx
```

---

## 3) ❌ YAML formatting / indentation errors

### ✅ Symptom

Errors like:

```text
mapping values are not allowed in this context
```

### 🧩 Cause

Handlers must be correctly nested under the play and must use list syntax (`-`).

### ✅ Fix

Validate YAML structure:

* plays begin with `- name: ...`
* tasks and handlers are lists
* consistent indentation

Run syntax check:

```bash id="k7p3m1"
ansible-playbook --syntax-check playbook.yml
```

---

## 4) ❌ Handler runs, but service fails to restart

### ✅ Symptom

Handler runs but restart fails, or nginx becomes inactive.

### 🧩 Causes

* Bad configuration changes (syntax error in nginx.conf)
* Service name incorrect
* Permission issues (missing `become: yes`)

### ✅ Fix

Check nginx config before restart (safe validation step):

```bash id="n0m8x2"
sudo nginx -t
```

Check system service logs:

```bash id="z1p9v4"
sudo journalctl -u nginx --no-pager -n 50
```

Ensure playbook escalates privileges:

```yaml
become: yes
```

---

## 5) ❌ Handler runs at the end, but you need restart immediately

### ✅ Symptom

A later task depends on the restarted service, but handler runs only after play ends.

### 🧩 Cause

Handlers are queued and run at end of play by default.

### ✅ Fix

Force handlers to execute immediately:

```yaml id="b2m8k0"
- meta: flush_handlers
```

---

## 6) ❌ Multiple notifications cause multiple restarts (expected only one)

### ✅ Symptom

You think handler will restart multiple times.

### ✅ Reality

Ansible will run the same handler only **once per play** even if notified multiple times.

### ✅ Fix

No action needed—this is expected behavior and a key benefit of handlers.

---

## 7) ❌ Service name issues on different Linux distributions

### ✅ Symptom

Handler fails because service name differs across OS.

### 🧩 Cause

Service names vary:

* Ubuntu: `nginx`
* RHEL/CentOS: also typically `nginx` but can differ depending on packaging

### ✅ Fix

Verify the service name:

```bash id="t1m4x9"
systemctl list-units --type=service | grep -i nginx
```

---

## 8) ✅ Verification checklist

Use these to confirm successful lab completion:

Check handler behavior:

* First run should show `changed` + handler execution
* Second run should show `ok` and no handler execution

Check service status:

```bash id="c8n2p4"
systemctl status nginx --no-pager
```

Confirm config line exists:

```bash id="p6m1w8"
grep -n "^worker_processes" /etc/nginx/nginx.conf
```

---
