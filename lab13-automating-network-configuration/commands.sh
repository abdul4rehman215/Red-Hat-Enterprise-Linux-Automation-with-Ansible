#!/bin/bash
# Lab 13 - Automating Network Configuration
# Commands Executed During Lab (sequential, no explanations)

# --- Connect to control node ---
ssh student@ansible-controller

# --- Verify Ansible connectivity ---
ansible all -m ping
ansible all -m shell -a "ip addr show"
ansible all -m shell -a "nmcli connection show"

# --- Create lab working directory ---
mkdir ~/lab13-network-automation
cd ~/lab13-network-automation

# --- Create inventory ---
nano inventory

# --- Test inventory connectivity ---
ansible -i inventory all -m ping

# --- Create static IP playbook ---
nano configure-static-ip.yml

# --- Check collections and install community.general if missing ---
ansible-galaxy collection list | head
ansible-galaxy collection install community.general

# --- Run static IP playbook ---
ansible-playbook -i inventory configure-static-ip.yml

# --- Verify new IP addresses ---
ansible -i inventory all -m shell -a "ip addr show"

# --- Create secondary interface playbook ---
nano configure-secondary-interface.yml

# --- Run secondary interface playbook ---
ansible-playbook -i inventory configure-secondary-interface.yml

# --- List all connections after adding secondary profile ---
ansible -i inventory all -m shell -a "nmcli connection show"

# --- Create routing playbook ---
nano configure-routing.yml

# --- Apply routing configuration ---
ansible-playbook -i inventory configure-routing.yml

# --- Verify routing table ---
ansible -i inventory all -m shell -a "ip route show"

# --- Create DNS configuration playbook ---
nano configure-dns.yml

# --- Create templates directory and resolv.conf template ---
mkdir -p templates
nano templates/resolv.conf.j2

# --- Apply DNS configuration ---
ansible-playbook -i inventory configure-dns.yml

# --- Test DNS resolution (ad-hoc) ---
ansible -i inventory all -m shell -a "nslookup google.com"

# --- Create master network config playbook ---
nano master-network-config.yml

# --- Run master playbook ---
ansible-playbook -i inventory master-network-config.yml

# --- Create validation playbook ---
nano validate-network.yml

# --- Create reports directory and run validation ---
mkdir -p reports
ansible-playbook -i inventory validate-network.yml

# --- Review fetched reports ---
ls -la reports/
cat reports/node1_network_report.txt

# --- Troubleshooting: Ensure NetworkManager is running ---
ansible -i inventory all -m service -a "name=NetworkManager state=started enabled=yes" --become

# --- Troubleshooting: Check resolv.conf ---
ansible -i inventory all -m shell -a "cat /etc/resolv.conf"

# --- Troubleshooting: Restart NetworkManager ---
ansible -i inventory all -m service -a "name=NetworkManager state=restarted" --become

# --- Troubleshooting: dig missing -> try dig, then install bind-utils, then retry ---
ansible -i inventory all -m shell -a "dig @8.8.8.8 google.com | head"
ansible -i inventory all -m yum -a "name=bind-utils state=present" --become
ansible -i inventory all -m shell -a "dig @8.8.8.8 google.com | head"

# --- Troubleshooting: Verify route persistence files ---
ansible -i inventory all -m shell -a "ls -la /etc/sysconfig/network-scripts/route-*"
ansible -i inventory all -m shell -a "nmcli connection show"

# --- Advanced examples: VLAN and bonding playbooks (created) ---
nano configure-vlan.yml
nano configure-bonding.yml
