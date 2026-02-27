# 🛠️ Lab 12: User and Group Management — Troubleshooting Guide

> This guide covers common issues when automating Linux users/groups with Ansible `user` and `group` modules, including shells, memberships, and home directory changes.

---

## 1) ❌ Permission denied / “You must be root” errors

### ✅ Symptoms
- Playbook fails with permission-related errors when creating users/groups
- Errors like:
  - `permission denied`
  - `useradd: Permission denied`
  - `You must be root to perform this action`

### 🔍 Likely Causes
- `become: yes` missing
- sudo privileges not available
- Ansible running as a non-privileged user

### ✅ Fix / Resolution
Ensure tasks are executed with privilege escalation:
```yaml
become: yes
````

Run playbook normally (Ansible handles sudo):

```bash
ansible-playbook -i inventory.ini playbook.yml
```

---

## 2) ❌ Group already exists / GID conflicts

### ✅ Symptoms

* Playbook fails creating a group:

  * `groupadd: GID '3001' already exists`
  * group name already exists with another ID

### 🔍 Likely Causes

* Another group already uses that GID
* Lab environment already had the group pre-created
* GID policy overlaps with system-reserved IDs

### ✅ Fix / Resolution

1. Inspect existing GIDs:

```bash
getent group | sort -t: -k3 -n | tail -n 30
```

2. Change your playbook GIDs to unused values (e.g., 4001+):

```yaml
gid: 4001
```

3. If you intentionally want the existing group, keep `state: present` and remove `gid` pinning.

---

## 3) ❌ User already exists / UID conflicts

### ✅ Symptoms

* `useradd: UID 2001 is not unique`
* Playbook fails creating a user

### 🔍 Likely Causes

* UID already used
* User already exists from earlier runs

### ✅ Fix / Resolution

1. Check if user exists:

```bash
getent passwd alice
```

2. If recreating lab state, remove user first:

```yaml
- name: Remove user
  user:
    name: alice
    state: absent
    remove: yes
```

3. Or choose a different UID range.

---

## 4) ❌ Shell change fails: `/bin/zsh does not exist`

### ✅ Symptoms

* Example from this lab:

  * `usermod: no changes`
  * `/bin/zsh does not exist`

### 🔍 Likely Causes

* zsh is not installed
* the shell path isn’t listed in `/etc/shells` yet

### ✅ Fix / Resolution

1. Check available shells:

```bash
cat /etc/shells
```

2. Install zsh:

* RHEL/CentOS:

```bash
sudo yum -y install zsh
```

3. Retry setting the shell:

```yaml
- name: Change alice shell to zsh
  user:
    name: alice
    shell: /bin/zsh
```

✅ In this lab, the playbook used **block/rescue** and then installed zsh before retrying.

---

## 5) ❌ Group membership not as expected after changes

### ✅ Symptoms

* User is missing previous groups
* `groups <user>` output changed unexpectedly

### 🔍 Likely Causes

* `append: no` replaced all supplementary groups
* you expected additive behavior but overwrite occurred

### ✅ Fix / Resolution

Use `append: yes` when you want to add groups without removing existing memberships:

```yaml
- name: Add alice to testers
  user:
    name: alice
    groups: developers,testers
    append: yes
```

Use `append: no` only when you intentionally want to replace membership.

---

## 6) ❌ Home directory move fails or content missing

### ✅ Symptoms

* Home directory path updates but files don’t move
* Permission errors during home migration
* New home exists but is empty

### 🔍 Likely Causes

* `move_home: yes` missing
* source directory doesn’t exist
* file permissions prevent copying/moving

### ✅ Fix / Resolution

Ensure you include:

```yaml
move_home: yes
```

Also verify the old home exists before copying:

```bash
ls -la /home/eve
```

In this lab, the playbook safely attempted copying with `ignore_errors: yes` to avoid failing if dotfiles or files don’t exist.

---

## 7) ❌ Symlink creation fails

### ✅ Symptoms

* Link task fails
* symlink exists but points to wrong path

### 🔍 Likely Causes

* target directory does not exist
* permission issues on destination path
* wrong `src` vs `dest` usage

### ✅ Fix / Resolution

1. Ensure shared directory exists first:

```yaml
- name: Create shared directory
  file:
    path: /home/shared/project-alpha
    state: directory
```

2. Create the symlink correctly:

```yaml
- name: Create symlink
  file:
    src: /home/shared/project-alpha
    dest: /home/bob/project-alpha
    state: link
```

---

## 8) ❌ “groups: command not found” or inconsistent group output

### ✅ Symptoms

* `groups <user>` fails in minimal environments

### 🔍 Likely Causes

* coreutils missing or restricted environment (rare)
* user shell environment restrictions

### ✅ Fix / Resolution

Use `id` as a more standard alternative:

```bash
id alice
id bob
```

---

## 9) ❌ Account lock causes login failures (expected but surprising)

### ✅ Symptoms

* User cannot log in after automation changes
* SSH denies login for locked user

### 🔍 Likely Causes

* `password_lock: yes` locks the password, which blocks password-based logins
* If key access also restricted, user becomes fully locked out

### ✅ Fix / Resolution

Unlock when needed:

```yaml
- name: Unlock user
  user:
    name: carol
    password_lock: no
```

Use locks carefully for incident response and inactive accounts.

---

## 10) ❌ Password aging command fails (`chage` errors)

### ✅ Symptoms

* `chage -M 90 eve` fails

### 🔍 Likely Causes

* user doesn’t exist yet
* `chage` not available (rare)
* insufficient permissions

### ✅ Fix / Resolution

1. Confirm user exists:

```bash
getent passwd eve
```

2. Confirm chage exists:

```bash
which chage
```

3. Ensure `become: yes` is enabled.

---

## ✅ Quick “Known Good” Verification Commands (from this lab)

### Verify users/groups exist

```bash
getent passwd | grep -E "(alice|bob|carol|david|eve|frank|grace)"
getent group  | grep -E "(developers|testers|managers|contractors|project-alpha|sysadmins)"
```

### Verify shells

```bash
getent passwd alice | cut -d: -f1,7
getent passwd bob   | cut -d: -f1,7
getent passwd eve   | cut -d: -f1,7
```

### Verify group memberships

```bash
groups alice
groups bob
groups david
groups eve
```

### Verify home directories

```bash
getent passwd eve | cut -d: -f6
ls -ld /home/alice /home/bob /home/carol /home/david /opt/users/eve /home/frank /home/grace
```

---

✅ **Troubleshooting complete for Lab 12.**
