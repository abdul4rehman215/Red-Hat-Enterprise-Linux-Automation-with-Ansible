#!/bin/bash
# Lab 10 - Managing Files with Ansible
# Commands Executed During Lab
# Only commands executed. No explanations.

# ------------------------------
# Task 1: Workspace Setup + Static Files
# ------------------------------
cd /home/student/ansible-labs
sudo mkdir -p /home/student/ansible-labs
sudo chown -R $(whoami):$(whoami) /home/student
cd /home/student/ansible-labs
pwd

mkdir lab10-file-management
cd lab10-file-management
pwd

mkdir -p static-files
nano static-files/apache-security.conf

nano copy-static-files.yml

ls -la
echo "FAVICON" > static-files/favicon.ico
ls -la static-files/

nano inventory.ini

ansible-playbook -i inventory.ini copy-static-files.yml

ansible webservers -i inventory.ini -m shell -a "ls -la /etc/httpd/conf.d/security.conf"
ansible webservers -i inventory.ini -m shell -a "ls -la /var/www/html/"

# ------------------------------
# Task 2: Templates (Jinja2) + Variables
# ------------------------------
mkdir templates
nano templates/vhost.conf.j2
nano templates/system-info.conf.j2

mkdir -p group_vars
nano group_vars/webservers.yml

mkdir -p host_vars
nano host_vars/web1.yml
nano host_vars/web2.yml

nano deploy-templates.yml

nano templates/index.html.j2

ansible-playbook -i inventory.ini deploy-templates.yml

ansible webservers -i inventory.ini -m shell -a "ls -la /etc/httpd/conf.d/"
ansible webservers -i inventory.ini -m shell -a "head -20 /etc/system-info.conf"
ansible webservers -i inventory.ini -m shell -a "cat /etc/httpd/conf.d/web*.conf"

# ------------------------------
# Task 3: Advanced File Management + Testing
# ------------------------------
nano advanced-file-management.yml

nano test-file-management.yml

nano templates/conditional-template.j2

ansible-playbook -i inventory.ini advanced-file-management.yml
ansible-playbook -i inventory.ini test-file-management.yml

ansible webservers -i inventory.ini -m shell -a "find /opt/app -type f -ls"
ansible webservers -i inventory.ini -m shell -a "cat /opt/app/config/system-info.conf"
ansible webservers -i inventory.ini -m shell -a "ls -la /tmp/*.conf /tmp/*.txt 2>/dev/null"

# ------------------------------
# Troubleshooting / Validation
# ------------------------------
ansible-playbook --syntax-check deploy-templates.yml
ansible-lint deploy-templates.yml
sudo yum -y install ansible-lint
