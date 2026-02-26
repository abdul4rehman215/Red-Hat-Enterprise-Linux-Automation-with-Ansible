#!/bin/bash
# Lab 19 - Error Handling and Debugging
# Commands Executed During Lab (Sequential)

# -----------------------------
# Task 1.1 - Create Lab Directory + Inventory + Debug Playbook
# -----------------------------

mkdir -p ~/lab19-error-handling
cd ~/lab19-error-handling

nano inventory
nano debug-variables.yml

ansible-playbook -i inventory debug-variables.yml

# -----------------------------
# Task 1.2 - Advanced Debug Techniques
# -----------------------------

nano advanced-debug.yml

# Normal output
ansible-playbook -i inventory advanced-debug.yml

# Verbose output
ansible-playbook -i inventory advanced-debug.yml -v

# -----------------------------
# Task 2.1 - Create Playbook for Check Mode Testing
# -----------------------------

nano system-changes.yml

# -----------------------------
# Task 2.2 - Test with Check Mode + Diff
# -----------------------------

ansible-playbook -i inventory system-changes.yml --check
ansible-playbook -i inventory system-changes.yml --check --diff

# -----------------------------
# Task 2.2 (continued) - Check-Mode Aware Playbook
# -----------------------------

nano check-mode-aware.yml

# Check mode run
ansible-playbook -i inventory check-mode-aware.yml --check

# Normal mode run
ansible-playbook -i inventory check-mode-aware.yml

# -----------------------------
# Task 3.1 - Basic Error Handling with ignore_errors
# -----------------------------

nano basic-error-handling.yml
ansible-playbook -i inventory basic-error-handling.yml

# -----------------------------
# Task 3.2 - Advanced Error Handling with block/rescue/always
# -----------------------------

nano advanced-error-handling.yml
ansible-playbook -i inventory advanced-error-handling.yml

# -----------------------------
# Task 3.3 - Error Handling Best Practices (Retries, Validation, Reporting)
# -----------------------------

nano error-handling-best-practices.yml
ansible-playbook -i inventory error-handling-best-practices.yml

# -----------------------------
# Task 3.4 - Comprehensive Error Handling Template
# -----------------------------

nano error-handling-template.yml
ansible-playbook -i inventory error-handling-template.yml

# -----------------------------
# Verification Playbook
# -----------------------------

nano verify-lab-completion.yml
ansible-playbook -i inventory verify-lab-completion.yml
