#!/bin/bash
# Lab 09 - Using Roles in Playbooks
# Commands Executed During Lab
# Only commands executed. No explanations.

# ------------------------------
# Task 1: Role Structure Setup
# ------------------------------
cd ~
mkdir -p ansible-lab9/roles
cd ansible-lab9
pwd

mkdir -p roles/apache-webserver/{tasks,handlers,templates,files,vars,defaults,meta}
tree roles/

nano role-structure-guide.txt

# ------------------------------
# Task 2: Create Apache Role (Tasks + Defaults + Vars)
# ------------------------------
nano roles/apache-webserver/tasks/main.yml
nano roles/apache-webserver/defaults/main.yml
nano roles/apache-webserver/vars/main.yml

# ------------------------------
# Task 3: Create Handlers
# ------------------------------
nano roles/apache-webserver/handlers/main.yml

# ------------------------------
# Task 4: Create Templates
# ------------------------------
nano roles/apache-webserver/templates/index.html.j2
nano roles/apache-webserver/templates/vhost.conf.j2

# ------------------------------
# Task 5: Create Role Metadata
# ------------------------------
nano roles/apache-webserver/meta/main.yml

# ------------------------------
# Task 6: Use Role in Playbooks
# ------------------------------
nano deploy-webserver.yml
nano deploy-webserver-advanced.yml

# ------------------------------
# Task 6.3: Create Inventory
# ------------------------------
nano inventory.ini

# ------------------------------
# Task 7: Execute Role-Based Playbooks
# ------------------------------
ansible-playbook -i inventory.ini deploy-webserver.yml
ansible-playbook -i inventory.ini deploy-webserver-advanced.yml

curl http://192.168.1.10
curl http://192.168.1.11

ansible web_servers -i inventory.ini -m service -a "name=httpd state=started" --become
ansible web_servers -i inventory.ini -m shell -a "httpd -t" --become

# ------------------------------
# Task 8: Create Common Role + Multi-Role Playbook
# ------------------------------
mkdir -p roles/common/{tasks,handlers,defaults}
nano roles/common/tasks/main.yml
nano roles/common/defaults/main.yml

nano site.yml
ansible-playbook -i inventory.ini site.yml

# ------------------------------
# Task 9: Validation Playbook + Role Documentation
# ------------------------------
nano validate-deployment.yml
ansible-playbook -i inventory.ini validate-deployment.yml

nano roles/apache-webserver/README.md
