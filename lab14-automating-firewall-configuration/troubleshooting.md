# 🛠️ troubleshooting Guide — Lab 14: Automating Firewall Configuration (Ansible + firewalld)

> This file documents common issues encountered while automating firewalld using Ansible, along with fixes, commands, and verification steps.

---

## 🧩 Issue 1: firewalld Service Not Running

### ❗ Problem
- `firewall-cmd` returns errors such as:
  - `FirewallD is not running`
  - `Failed to connect to socket /var/run/dbus/system_bus_socket`
- Ansible `firewalld` module tasks fail.

### ✅ Cause
- firewalld package missing or service stopped/disabled
- conflicting firewall stack (legacy iptables service)

### ✅ Fix (Ansible)
Use the troubleshooting playbook:

```bash
ansible-playbook -i inventory troubleshoot-firewalld.yml
````

### 📌 What the playbook does

* Checks installed packages
* Installs firewalld if missing
* Stops iptables if conflicting
* Starts/enables firewalld
* Prints `systemctl status firewalld`

---

## 🧩 Issue 2: Rules Not Persisting After Reboot

### ❗ Problem

Rules seem active after playbook run, but disappear after reboot.

### ✅ Cause

Rules were applied only in runtime configuration, not permanent config.

### ✅ Fix / Best Practice

Always set BOTH:

* `permanent: yes`
* `immediate: yes`

Example:

```yaml
firewalld:
  service: http
  permanent: yes
  immediate: yes
  state: enabled
```

### ✅ Verification Commands

```bash
firewall-cmd --list-all
firewall-cmd --runtime-to-permanent
firewall-cmd --reload
```

---

## 🧩 Issue 3: Zone Configuration Problems

### ❗ Problem

Rules are applied but traffic is still blocked (or unexpectedly allowed), usually because the interface is assigned to a different zone than expected.

### ✅ Cause

The interface belongs to a different zone (example: `internal` vs `public`), so rules were applied in the wrong zone.

### ✅ Fix / Verify Zone Assignment

List all zones and their configs:

```bash
ansible all -m command -a "firewall-cmd --list-all-zones" --become
```

Check which zone an interface belongs to:

```bash
ansible all -m command -a "firewall-cmd --get-zone-of-interface=eth0" --become
```

### 📌 Output (example)

```text
node1 | CHANGED | rc=0 >>
public
node2 | CHANGED | rc=0 >>
public
```

---

## 🧩 Issue 4: Locked Out After Firewall Changes

### ❗ Problem

SSH access fails after firewall changes.

### ✅ Cause

SSH service/port was not allowed in active zone, or was disabled accidentally.

### ✅ Fix (Emergency)

Re-enable SSH:

```bash
ansible -i inventory all -m firewalld -a "service=ssh permanent=yes immediate=yes state=enabled" --become
```

Verify:

```bash
ansible -i inventory all -m command -a "firewall-cmd --list-services" --become
```

---

## 🧩 Issue 5: Custom Service Not Recognized (`custom-app`)

### ❗ Problem

Enabling the custom service fails:

* `INVALID_SERVICE: custom-app`

### ✅ Cause

* XML service file not placed correctly
* firewalld not reloaded after creating the XML service definition

### ✅ Fix

1. Ensure XML exists:

```bash
ansible -i inventory all -m shell -a "ls -la /etc/firewalld/services/custom-app.xml" --become
```

2. Reload firewalld:

```bash
ansible -i inventory all -m command -a "firewall-cmd --reload" --become
```

3. Retry enabling:

```bash
ansible -i inventory all -m firewalld -a "service=custom-app permanent=yes immediate=yes state=enabled" --become
```

---

## 🧩 Issue 6: Rich Rule Syntax Errors

### ❗ Problem

Playbook fails with rich rule parsing errors.

### ✅ Cause

Rich rules are strict about quoting, spacing, and required fields (family/source/service/port).

### ✅ Fix

* Validate rule syntax carefully
* Test interactively:

```bash
firewall-cmd --add-rich-rule='rule family="ipv4" source address="192.168.1.0/24" service name="ssh" accept'
firewall-cmd --list-rich-rules
```

If the rule works in CLI, port it into Ansible.

---

## ✅ Best Practices Summary

1. Always use both `permanent` and `immediate` for stable firewall configs
2. Validate rules after application (ports/services/rich rules)
3. Use **zones** to enforce segmentation and trust levels
4. Implement **least privilege**: open only what is required
5. Use **rich rules** for granular control (source allow/deny, rate limiting, logging)
6. Maintain backups of firewall config for audits and rollback
7. Use automated testing to prevent accidental exposures or lockouts

---

## ✅ Quick Validation Checklist (Post-Run)

```bash
ansible -i inventory all -m command -a "firewall-cmd --state" --become
ansible -i inventory all -m command -a "firewall-cmd --list-all" --become
ansible -i inventory all -m command -a "firewall-cmd --list-rich-rules" --become
ansible -i inventory all -m command -a "firewall-cmd --get-zone-of-interface=eth0" --become
```
