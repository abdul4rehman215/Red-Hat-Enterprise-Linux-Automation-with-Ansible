# 🎤 Lab 12: User and Group Management — Interview Q&A

## 1) What is the difference between a user’s primary group and secondary groups?
- **Primary group** is the default group assigned to a user (shown as GID in `/etc/passwd`).
- **Secondary groups** are additional groups that grant extra permissions (stored in `/etc/group` membership list).
In this lab, `david` had a primary group of `managers` and secondary membership in `developers`, `testers`, and later `sysadmins`.

---

## 2) Why use Ansible for user and group management instead of manual commands?
Automation provides:
- consistent account creation across systems
- fewer human errors
- repeatable onboarding/offboarding
- audit-friendly changes (version controlled playbooks)
- easy scaling to many hosts

---

## 3) What does the Ansible `group` module do?
The `group` module manages Linux groups:
- creates groups (`state: present`)
- removes groups (`state: absent`)
- can set a specific group ID (`gid`)
In this lab, groups like `developers`, `testers`, and `sysadmins` were created with fixed GIDs.

---

## 4) What does the Ansible `user` module do?
The `user` module manages Linux user accounts:
- creates/removes users
- sets shell, UID, home directory
- assigns primary and secondary groups
- can create/move home directories
- can lock accounts (`password_lock: yes`)

---

## 5) Why is specifying `uid` and `gid` useful in enterprise environments?
Using consistent UID/GID ranges helps:
- prevent identity mismatches across multiple servers
- avoid permissions problems on shared storage (NFS, SMB)
- simplify auditing and access reviews
- enforce organizational policy for account ranges

---

## 6) What does `create_home: yes` do?
It ensures the user’s home directory is created automatically (if it doesn’t exist) during user creation.

---

## 7) What is the purpose of `append: yes` when modifying groups?
`append: yes` adds new group membership while preserving existing group memberships.  
Without append, group membership may be replaced.

Example: Alice was added to `testers` while still remaining in `developers`.

---

## 8) What is the effect of `append: no` in user group changes?
`append: no` replaces the user’s supplementary groups with the provided list.  
In this lab, Eve was moved from `contractors` to `developers`, removing the old contractor group membership.

---

## 9) Why did you handle the `/bin/zsh` shell change using block/rescue?
Because `/bin/zsh` might not exist until zsh is installed.  
The playbook first attempted to set the shell:
- if it failed due to missing `/bin/zsh`, it fell back to bash
- then installed zsh and retried setting zsh

This makes the playbook robust and realistic.

---

## 10) What does `move_home: yes` do?
When changing a user’s home directory, `move_home: yes` migrates existing content to the new home directory path.

In this lab, Eve’s home moved from `/home/eve` to `/opt/users/eve`.

---

## 11) Why create a shared project directory with group permissions (e.g., 0770)?
A shared directory with:
- group ownership (project group)
- permissions `0770`
ensures:
- group members can collaborate (read/write)
- non-group users are blocked
- access is controlled using group membership

This is a common enterprise pattern for team collaboration.

---

## 12) Why create a symlink inside Bob’s home to the shared project directory?
Symlinks improve usability:
- Bob can access the shared folder from a predictable location (`~/project-alpha`)
- avoids duplicating data
- keeps team workspace centralized

---

## 13) Why lock an account like `carol` in automation?
Locking accounts is useful for:
- temporary inactivity
- security incidents
- role changes
- minimizing attack surface while keeping user records
This lab used `password_lock: yes` for a “temporarily unused account” scenario.

---

## 14) What is the purpose of password aging (`chage -M 90`)?
Password aging enforces:
- periodic credential rotation
- compliance requirements
- reduced risk from long-lived passwords
This is especially relevant for contractor or non-permanent accounts.

---

## 15) What does the verification playbook add to an automation workflow?
It ensures the final state is correct:
- users exist
- groups exist
- shells match expected values
- home directories exist
- outputs a final success summary

Verification playbooks reduce drift and provide confidence for enterprise automation changes.
