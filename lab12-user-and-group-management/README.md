# 🧪 Lab 12: User and Group Management (Ansible `user` + `group`)

## 📌 Lab Summary
This lab automated **Linux user and group administration** using Ansible modules:

- `group` module for **creating and managing groups**
- `user` module for **creating and managing users**
- Updating user properties:
  - shells
  - secondary group memberships
  - home directories (including migration + symlinks)
- Advanced operations:
  - creating users from a variable list (loop-driven provisioning)
  - password aging (contractor policy)
  - account locking (temporarily unused accounts)
- Verification playbook to confirm users/groups/shells/home dirs are correct

All tasks were executed **locally** (`localhost ansible_connection=local`) to keep the lab simple and realistic for a single-node admin workflow.

---

## 🎯 Objectives
By the end of this lab, I was able to:

- Create and manage user accounts using Ansible `user` module
- Create and manage groups using Ansible `group` module
- Modify user properties (shell, groups, home directories)
- Understand user/group relationships (primary vs secondary groups)
- Write automated user-management playbooks with best practices
- Validate configurations using verification playbooks

---

## ✅ Prerequisites
- Basic Linux CLI familiarity
- YAML structure basics
- Ansible fundamentals (inventory/playbooks/modules)
- Understanding of permissions/ownership (users and groups)
- Text editor usage (`nano`)

---

## 🖥️ Lab Environment
- **Platform:** Pre-configured cloud lab Linux system
- **OS family:** CentOS/RHEL-based
- **Access:** Root/sudo available
- **Ansible:** Pre-installed on the system
- **Scope:** Localhost automation

---

## 🗂️ Repository Structure
```text
lab12-user-and-group-management/
├── README.md
├── commands.sh
├── output.txt
├── interview_qna.md
├── troubleshooting.md
├── inventory.ini
├── create-groups.yml
├── create-users.yml
├── modify-shells.yml
├── modify-groups.yml
├── modify-home-dirs.yml
├── advanced-user-management.yml
└── verify-user-management.yml
````

---

## ✅ Tasks Overview (What I Did)

### 🧱 Task 1: Inventory + Group Creation

* Created a local inventory (`localhost ansible_connection=local`)
* Created multiple groups with fixed GIDs for consistency:

  * `developers (3001)`
  * `testers (3002)`
  * `managers (3003)`
  * `contractors (3004)`
* Verified using `getent group`

---

### 👤 Task 1.3: User Creation (User Module)

Created users with:

* specific UIDs
* primary group
* secondary groups
* shells
* home directories + create_home

Users:

* `alice` (developer)
* `bob` (developer)
* `carol` (tester)
* `david` (manager with cross-team membership)
* `eve` (contractor)

Verified via `getent passwd`.

---

## ✅ Task 2: Modify Users (Shells, Groups, Home Directories)

### 🐚 Task 2.1: Modify Shells

* Attempted to set Alice’s shell to `/bin/zsh`

  * handled missing zsh case using **block/rescue**
  * installed zsh afterward
  * updated Alice to `/bin/zsh`
* Ensured:

  * `bob` remains `/bin/bash`
  * `eve` remains `/bin/sh`

Verified shells using `getent passwd ... | cut -d: -f1,7`.

---

### 👥 Task 2.2: Modify Group Memberships

* Added `alice` to `testers` (cross-functional)
* Created `project-alpha (gid 3005)` and added `bob`
* Converted `eve` from contractors to developers (append: no)
* Created `sysadmins (gid 3006)` and placed `david` into sysadmins + other relevant groups

Verified memberships with `groups <user>`.

---

### 🏠 Task 2.3: Modify Home Directories

* Created `/opt/users` structure
* Migrated Eve’s home to `/opt/users/eve` (`move_home: yes`)
* Created shared directory `/home/shared/project-alpha` with group `project-alpha` and permissions `0770`
* Symlinked `/home/bob/project-alpha` → shared directory
* Tightened Alice home permissions and created workspace directory

Verified home dirs and permissions via `getent passwd` and `ls -ld`.

---

## ✅ Task 3: Advanced User Management + Verification

### 🧰 Task 3.1: Advanced User Management Playbook

* Provisioned users from a variable list (loop-based):

  * `frank` (DevOps Engineer)
  * `grace` (Security Analyst)
* Created standard folders for each new user:

  * Documents / Downloads / Projects
* Applied account policy examples:

  * password aging for Eve (`chage -M 90 eve`)
  * locked Carol account (temporarily unused)
* Generated a `/tmp/user_report.txt` summarizing users and groups

---

### ✅ Task 3.2: Verification Playbook

Created `verify-user-management.yml` to confirm:

* all users exist
* all groups exist
* shells match expectations
* home directories exist
* prints a final summary banner

---

## 🏁 Result

✅ Successfully automated user and group lifecycle tasks end-to-end:

* groups created consistently with fixed IDs
* users created with correct ownership, shells, and homes
* membership updates applied cleanly
* home directory migration + shared directories + symlinks implemented
* validation playbook confirms final state

---

## 🔐 Security Relevance

User and group management is foundational for:

* **least privilege** access design
* role-based access control (RBAC-style group membership)
* controlled shell access (e.g., contractor accounts)
* consistent UID/GID planning for enterprise systems
* secure home directory permissions and shared project spaces

---

## ✅ Conclusion

This lab demonstrates practical enterprise-style Linux administration with Ansible: consistent provisioning, controlled access via groups, safe updates (shell + home changes), and a verification workflow to ensure changes are correct and repeatable.

✅ Lab completed successfully.
