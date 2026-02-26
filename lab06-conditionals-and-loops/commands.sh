#!/bin/bash
# Lab 06 - Conditionals and Loops in Ansible
# Commands Executed During Lab (Sequential)

# ==========================================
# Task 1: Setup Lab Directory
# ==========================================
mkdir ~/lab6-conditionals-loops
cd ~/lab6-conditionals-loops

# ==========================================
# Task 1.1: Basic Conditional Statements
# ==========================================
nano basic-conditionals.yml
ansible-playbook -i inventory basic-conditionals.yml

# ==========================================
# Task 1.2: Advanced Conditional Logic
# ==========================================
nano advanced-conditionals.yml
ansible-playbook -i inventory advanced-conditionals.yml

# ==========================================
# Task 2.1: Basic Loop Structures
# ==========================================
nano basic-loops.yml
ansible-playbook -i inventory basic-loops.yml

# ==========================================
# Task 2.2: Advanced Loop Techniques
# ==========================================
nano advanced-loops.yml
ansible-playbook -i inventory advanced-loops.yml

# ==========================================
# Task 2.3: Loop Control and Filtering
# ==========================================
nano loop-control.yml
ansible-playbook -i inventory loop-control.yml

# ==========================================
# Task 3.1: Combining Conditionals and Loops
# ==========================================
nano combined-logic.yml
ansible-playbook -i inventory combined-logic.yml
ansible-playbook -i inventory combined-logic.yml -e "server_role=database"
ansible-playbook -i inventory combined-logic.yml -e "environment=development"

# ==========================================
# Task 3.2: Error Handling and Validation
# ==========================================
nano error-handling.yml
ansible-playbook -i inventory error-handling.yml

# ==========================================
# Task 4.1: Multi-Environment Deployment Scenario
# ==========================================
nano multi-environment-deploy.yml
mkdir templates
nano templates/app-config.j2

ansible-playbook -i inventory multi-environment-deploy.yml -e "env=development"
ansible-playbook -i inventory multi-environment-deploy.yml -e "env=staging"
ansible-playbook -i inventory multi-environment-deploy.yml -e "env=production"

# ==========================================
# Verification Playbook
# ==========================================
nano verify-lab.yml
ansible-playbook -i inventory verify-lab.yml
