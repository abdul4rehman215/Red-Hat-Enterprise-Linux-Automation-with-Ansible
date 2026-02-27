#!/bin/bash
# Lab 07 - Handlers and Notifications
# Commands Executed During Lab (Sequential)

# ==========================================
# Real Lab Prep: Install required tools
# ==========================================
sudo apt update
sudo apt install -y ansible nginx

# Quick verification
ansible --version

# ==========================================
# Task 1: Create lab directory and playbook
# ==========================================
mkdir -p ~/lab7-handlers
cd ~/lab7-handlers

nano playbook.yml

# Run playbook (first run should trigger handler)
ansible-playbook playbook.yml

# Run playbook again (no change -> handler won't run)
ansible-playbook playbook.yml

# ==========================================
# Verification: Confirm nginx service status
# ==========================================
systemctl status nginx --no-pager
