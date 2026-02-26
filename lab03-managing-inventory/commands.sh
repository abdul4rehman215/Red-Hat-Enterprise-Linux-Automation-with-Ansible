#!/bin/bash
# Lab 03 - Managing Inventory
# Commands Executed During Lab (Sequential)

# ==========================================
# Task 1: Connect to Control Node + Lab Setup
# ==========================================
ssh student@ansible-control

cd /home/student/ansible-labs
mkdir lab3-inventory
cd lab3-inventory

# ==========================================
# Task 1.1: Create Basic Static Inventory (INI)
# ==========================================
nano inventory.ini
cat inventory.ini

# ==========================================
# Task 1.2: Create Advanced Static Inventory (INI)
# ==========================================
nano advanced-inventory.ini
head -60 advanced-inventory.ini

# ==========================================
# Task 1.3: Create YAML Format Inventory
# ==========================================
nano inventory.yml
sed -n '1,80p' inventory.yml

# ==========================================
# Task 2: Dynamic Inventory Scripts
# ==========================================
nano dynamic-inventory.py
chmod +x dynamic-inventory.py

nano cloud-inventory.py
chmod +x cloud-inventory.py

# ==========================================
# Task 2.3: Test Dynamic Inventory Scripts
# ==========================================
./dynamic-inventory.py --list
./dynamic-inventory.py --host web1

./cloud-inventory.py --list

export CLOUD_PROVIDER=aws
export CLOUD_REGION=us-west-2
export ENVIRONMENT=staging
./cloud-inventory.py --list

# ==========================================
# Task 3.1: Basic Inventory Testing
# ==========================================
ansible all -i inventory.ini -m ping
ansible all -i inventory.ini --list-hosts
ansible webservers -i inventory.ini --list-hosts
ansible databases -i inventory.ini --list-hosts
ansible all -i inventory.yml -m ping

# ==========================================
# Task 3.2: Advanced Inventory Testing
# ==========================================
ansible all -i ./dynamic-inventory.py -m ping
ansible-inventory -i inventory.ini --list
ansible-inventory -i inventory.ini --host web1
ansible webservers -i inventory.ini -m debug -a "var=hostvars[inventory_hostname]"

# ==========================================
# Task 3.3: Comprehensive Inventory Validation (Playbook)
# ==========================================
nano test-inventory.yml
ansible-playbook -i inventory.ini test-inventory.yml
ansible-playbook -i inventory.yml test-inventory.yml
ansible-playbook -i ./dynamic-inventory.py test-inventory.yml

# ==========================================
# Task 3.4: Inventory Performance + Troubleshooting
# ==========================================
time ansible-inventory -i inventory.ini --list > /dev/null
time ansible-inventory -i ./dynamic-inventory.py --list > /dev/null

ansible-inventory -i inventory.ini --list --yaml
ansible all -i inventory.ini -m setup --tree /tmp/facts
ls -la /tmp/facts

ansible-inventory -i inventory.ini --list --yaml | head -20
ansible-playbook -i inventory.ini --syntax-check test-inventory.yml

ansible all -i inventory.ini -m ping -vvv

# ==========================================
# SSH Key Troubleshooting / Setup (If Needed)
# ==========================================
ssh-keygen -t rsa -b 2048 -f ~/.ssh/id_rsa
ssh-copy-id student@192.168.1.10
