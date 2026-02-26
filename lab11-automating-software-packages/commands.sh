#!/bin/bash
# Lab 11 - Automating Software Packages
# Commands Executed During Lab
# Only commands executed. No explanations.

# ------------------------------
# Task 1: Directory Structure + Inventory
# ------------------------------
mkdir -p ~/ansible-lab11/playbooks
mkdir -p ~/ansible-lab11/inventory
cd ~/ansible-lab11
pwd

nano inventory/hosts

ansible all -i inventory/hosts -m ping

# ------------------------------
# Task 1.2: Basic Package Installation
# ------------------------------
nano playbooks/install-basic-packages.yml
ansible-playbook -i inventory/hosts playbooks/install-basic-packages.yml

ansible all -i inventory/hosts -m command -a "which git" --become

# ------------------------------
# Task 1.3: Advanced Package Management (Install/Remove + Versions/States)
# ------------------------------
nano playbooks/advanced-package-management.yml
ansible-playbook -i inventory/hosts playbooks/advanced-package-management.yml

# ------------------------------
# Task 2.1: OS-Specific Package Management
# ------------------------------
nano playbooks/rhel-package-management.yml
nano playbooks/ubuntu-package-management.yml

ansible-playbook -i inventory/hosts playbooks/rhel-package-management.yml
ansible-playbook -i inventory/hosts playbooks/ubuntu-package-management.yml

# ------------------------------
# Task 2.2: Universal Package Management
# ------------------------------
nano playbooks/universal-package-management.yml
ansible-playbook -i inventory/hosts playbooks/universal-package-management.yml

# ------------------------------
# Task 2.3: Robust Package Management (Error Handling + Rollback Prep)
# ------------------------------
nano playbooks/robust-package-management.yml
ansible-playbook -i inventory/hosts playbooks/robust-package-management.yml

ansible all -i inventory/hosts -m command -a "ls -la /tmp/package_backup/" --become

# ------------------------------
# Task 2.4: Package Reporting (Dashboard/Reports)
# ------------------------------
nano playbooks/package-reporting.yml
ansible-playbook -i inventory/hosts playbooks/package-reporting.yml

ls -la /tmp/ansible_reports/
cat /tmp/ansible_reports/*_package_report.txt
