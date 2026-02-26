#!/bin/bash
# Lab 12 - User and Group Management
# Commands Executed During Lab
# Only commands executed. No explanations.

# ------------------------------
# Task 1: Lab Setup + Inventory
# ------------------------------
mkdir ~/lab12-user-management
cd ~/lab12-user-management
pwd

nano inventory.ini

# ------------------------------
# Task 1.2: Create Groups
# ------------------------------
nano create-groups.yml
ansible-playbook -i inventory.ini create-groups.yml

getent group | grep -E "(developers|testers|managers|contractors)"

# ------------------------------
# Task 1.3: Create Users
# ------------------------------
nano create-users.yml
ansible-playbook -i inventory.ini create-users.yml

getent passwd | grep -E "(alice|bob|carol|david|eve)"

# ------------------------------
# Task 2.1: Modify User Shells
# ------------------------------
nano modify-shells.yml
ansible-playbook -i inventory.ini modify-shells.yml

# ------------------------------
# Task 2.2: Modify Group Memberships
# ------------------------------
nano modify-groups.yml
ansible-playbook -i inventory.ini modify-groups.yml

# ------------------------------
# Task 2.3: Modify Home Directories
# ------------------------------
nano modify-home-dirs.yml
ansible-playbook -i inventory.ini modify-home-dirs.yml

# ------------------------------
# Task 3.1: Advanced User Management
# ------------------------------
nano advanced-user-management.yml
ansible-playbook -i inventory.ini advanced-user-management.yml

# ------------------------------
# Task 3.2: Verification
# ------------------------------
nano verify-user-management.yml
ansible-playbook -i inventory.ini verify-user-management.yml
