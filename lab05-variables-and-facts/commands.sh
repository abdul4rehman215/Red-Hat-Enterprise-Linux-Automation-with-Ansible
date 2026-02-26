#!/bin/bash
# Lab 05 - Variables and Facts
# Commands Executed During Lab (Sequential)

# ==========================================
# Task 1: Setup Lab Directory
# ==========================================
mkdir ~/lab5-variables-facts
cd ~/lab5-variables-facts

# ==========================================
# Task 1.1: Create Basic Variables Playbook
# ==========================================
nano variables-demo.yml

# Inventory discovery (inventory file existed in lab working directory)
ls -la
ansible-playbook -i inventory variables-demo.yml

# ==========================================
# Task 1.2: External Variable Files (group_vars)
# ==========================================
mkdir -p group_vars
nano group_vars/all.yml
nano external-vars-demo.yml
ansible-playbook -i inventory external-vars-demo.yml

# ==========================================
# Task 2.1: Facts Exploration
# ==========================================
nano facts-exploration.yml
ansible-playbook -i inventory facts-exploration.yml

# ==========================================
# Task 2.2: Custom Facts Setup + Display
# ==========================================
nano setup-custom-facts.yml
ansible-playbook -i inventory setup-custom-facts.yml

nano display-custom-facts.yml
ansible-playbook -i inventory display-custom-facts.yml

# ==========================================
# Task 3.1: OS-Specific Task Execution
# ==========================================
nano os-specific-tasks.yml
ansible-playbook -i inventory os-specific-tasks.yml

# ==========================================
# Task 3.2: Version-Specific Task Execution
# ==========================================
nano version-specific-tasks.yml
ansible-playbook -i inventory version-specific-tasks.yml

# ==========================================
# Task 3.3: Hardware-Based Task Modifications
# ==========================================
nano hardware-based-tasks.yml
ansible-playbook -i inventory hardware-based-tasks.yml

# ==========================================
# Task 4.1: Variable Precedence and Scope
# ==========================================
nano variable-precedence.yml

mkdir -p host_vars
nano host_vars/centos1.yml

ansible-playbook -i inventory variable-precedence.yml

# ==========================================
# Task 4.2: Dynamic Variable Creation
# ==========================================
nano dynamic-variables.yml
ansible-playbook -i inventory dynamic-variables.yml

# ==========================================
# Verification Playbook
# ==========================================
nano lab5-verification.yml
ansible-playbook -i inventory lab5-verification.yml
