#!/bin/bash
# Lab 04 - Introduction to Ansible Modules
# Commands Executed During Lab (Sequential)

# ==========================================
# Task 1: Understanding Ansible Modules
# ==========================================
ansible --version
ansible-doc -l | head -20
ansible-doc yum
ansible-doc apt
ansible-doc service

# ==========================================
# Task 1.2: Verify Inventory + Connectivity
# ==========================================
cat /etc/ansible/hosts
ansible all -m ping

# ==========================================
# Task 2.1: YUM Module Playbook (RHEL/CentOS)
# ==========================================
mkdir -p ~/ansible-labs/lab4
cd ~/ansible-labs/lab4
nano package-management.yml
ansible-playbook package-management.yml

# ==========================================
# Task 2.2: APT Module Playbook (Ubuntu/Debian)
# ==========================================
nano apt-management.yml
ansible-playbook apt-management.yml

# ==========================================
# Task 2.3: Cross-Platform Package Playbook
# ==========================================
nano universal-packages.yml
ansible-playbook universal-packages.yml

# ==========================================
# Task 3.1: Basic Service Management
# ==========================================
nano service-management.yml
ansible-playbook service-management.yml

# ==========================================
# Task 3.2: Advanced Service Operations
# ==========================================
nano advanced-services.yml
ansible-playbook advanced-services.yml

# ==========================================
# Task 4.1: Complete Infrastructure Playbook
# ==========================================
nano infrastructure-setup.yml
ansible-playbook infrastructure-setup.yml

# ==========================================
# Task 4.2: Verify Setup (Ad-hoc)
# ==========================================
ansible all -m service -a "name=httpd state=started" --become
ansible all -m service -a "name=apache2 state=started" --become
ansible all -m package -a "name=git state=present" --become
ansible all -m uri -a "url=http://localhost method=GET status_code=200"

# ==========================================
# Task 5.1: Error Handling Playbook
# ==========================================
nano error-handling.yml
ansible-playbook error-handling.yml

# ==========================================
# Verification Commands
# ==========================================
ansible all -m package -a "name=git state=present" --check
ansible all -m service -a "name=httpd" --become
ansible all -m service -a "name=apache2" --become
ansible all -m uri -a "url=http://localhost method=GET status_code=200"
ansible-playbook --syntax-check infrastructure-setup.yml
