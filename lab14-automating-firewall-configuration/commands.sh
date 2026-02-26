#!/bin/bash
# Lab 14 - Automating Firewall Configuration
# Commands Executed During Lab (sequential, no explanations)

# --- Verify Ansible installation on control node ---
ansible --version

# --- Verify connectivity to managed nodes ---
ansible all -m ping

# --- Ensure firewalld is running and enabled on managed nodes ---
ansible all -m systemd -a "name=firewalld state=started enabled=yes" --become

# --- Check firewall daemon state ---
ansible all -m command -a "firewall-cmd --state" --become

# --- Create lab directory ---
mkdir ~/firewall-lab
cd ~/firewall-lab

# --- Create inventory ---
nano inventory

# --- Create basic firewall playbook ---
nano basic-firewall.yml

# --- Run basic firewall playbook ---
ansible-playbook -i inventory basic-firewall.yml

# --- Create advanced firewall playbook ---
nano advanced-firewall.yml

# --- Run advanced firewall playbook ---
ansible-playbook -i inventory advanced-firewall.yml

# --- Create rich rules playbook ---
nano rich-rules.yml

# --- Run rich rules playbook ---
ansible-playbook -i inventory rich-rules.yml

# --- Create zones management playbook ---
nano zones-management.yml

# --- Run zones management playbook ---
ansible-playbook -i inventory zones-management.yml

# --- Create services management playbook ---
nano services-management.yml

# --- Run services management playbook ---
ansible-playbook -i inventory services-management.yml

# --- Create security policy playbook ---
nano security-policy.yml

# --- Run security policy playbook ---
ansible-playbook -i inventory security-policy.yml

# --- Create firewall testing playbook ---
nano firewall-testing.yml

# --- Run firewall testing playbook ---
ansible-playbook -i inventory firewall-testing.yml

# --- Troubleshooting playbook creation (firewalld issues) ---
nano troubleshoot-firewalld.yml

# --- Troubleshooting: list zones and zone assignments ---
ansible all -m command -a "firewall-cmd --list-all-zones" --become
ansible all -m command -a "firewall-cmd --get-zone-of-interface=eth0" --become
