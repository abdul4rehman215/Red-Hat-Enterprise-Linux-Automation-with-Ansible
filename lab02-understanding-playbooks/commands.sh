#!/bin/bash
# Lab 02 - Understanding Playbooks
# Commands Executed During Lab (Sequential)

# ==========================================
# Task 1: Explore Directory Structure
# ==========================================
cd /home/ansible
mkdir -p playbooks/lab2
cd playbooks/lab2
mkdir -p {group_vars,host_vars,roles,files,templates}
ls -la

# ==========================================
# Task 1.2: Create First Basic Playbook
# ==========================================
nano install-package.yml
ls -l

# ==========================================
# Task 2: Create Custom Inventory
# ==========================================
nano inventory.ini
cat inventory.ini

# ==========================================
# Task 2.2: Verify Inventory and Connectivity
# ==========================================
ansible-inventory -i inventory.ini --list
ansible -i inventory.ini managed_nodes -m ping
ansible -i inventory.ini managed_nodes -m setup --tree /tmp/facts
ls -la /tmp/facts

# ==========================================
# Task 3: Enhanced Playbook + Template
# ==========================================
nano enhanced-playbook.yml

mkdir -p templates
nano templates/index.html.j2

# ==========================================
# Task 4.1: Run Basic Playbook + Checks
# ==========================================
ansible-playbook -i inventory.ini install-package.yml -v
ansible-playbook -i inventory.ini install-package.yml --syntax-check
ansible-playbook -i inventory.ini install-package.yml --check

# ==========================================
# Task 4.2: Run Enhanced Playbook + Tags
# ==========================================
ansible-playbook -i inventory.ini enhanced-playbook.yml
ansible-playbook -i inventory.ini enhanced-playbook.yml --tags "packages,firewall"
ansible-playbook -i inventory.ini enhanced-playbook.yml --skip-tags "verification"

# ==========================================
# Task 4.3: Verify Results with Ad-hoc Commands
# ==========================================
ansible -i inventory.ini managed_nodes -m service -a "name=httpd state=started" --become
ansible -i inventory.ini managed_nodes -m shell -a "curl -s -o /dev/null -w '%{http_code}\n' http://localhost"
ansible -i inventory.ini managed_nodes -m file -a "path=/var/www/html/index.html" --become

# ==========================================
# Task 5: Troubleshooting Techniques
# ==========================================
ansible-playbook -i inventory.ini enhanced-playbook.yml -vvv

# Debugging playbook creation + run
nano debug-playbook.yml
ansible-playbook -i inventory.ini debug-playbook.yml

# ==========================================
# Task 5.2: Error Handling Playbook
# ==========================================
nano error-handling-playbook.yml
ansible-playbook -i inventory.ini error-handling-playbook.yml

# ==========================================
# Advanced: Reusable Variables + Variable-based Playbook
# ==========================================
nano vars.yml
nano variable-playbook.yml
ansible-playbook -i inventory.ini variable-playbook.yml

# ==========================================
# Verification Playbook
# ==========================================
nano verify-setup.yml
ansible-playbook -i inventory.ini verify-setup.yml
