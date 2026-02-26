#!/bin/bash
# Lab 08 - Writing Complex Playbooks
# Commands Executed During Lab
# Only commands executed. No explanations.

# ------------------------------
# Task 1: Multi-Play Structure Setup
# ------------------------------
mkdir -p ~/complex-playbook/{group_vars,host_vars,roles,templates,files}
cd ~/complex-playbook
pwd

nano site.yml
nano inventory.ini

ansible-playbook -i inventory.ini site.yml --check
ansible-playbook -i inventory.ini site.yml

# ------------------------------
# Task 2: Organizing Tasks by Roles
# ------------------------------
ansible-galaxy init roles/mysql
ansible-galaxy init roles/apache
ansible-galaxy init roles/webapp

nano roles/mysql/tasks/main.yml
nano roles/mysql/defaults/main.yml
nano roles/mysql/templates/my.cnf.j2
nano roles/mysql/handlers/main.yml

nano roles/apache/tasks/main.yml
nano roles/apache/defaults/main.yml
nano roles/apache/templates/vhost.conf.j2
nano roles/apache/handlers/main.yml

nano roles/webapp/tasks/main.yml
nano roles/webapp/defaults/main.yml
nano roles/webapp/templates/config.php.j2
nano roles/webapp/templates/index.php.j2
nano roles/webapp/templates/dbtest.php.j2

# ------------------------------
# Task 3: Role-Based Playbook + Group Vars + Full Deployment
# ------------------------------
nano site-with-roles.yml

nano group_vars/database_servers.yml
nano group_vars/web_servers.yml
nano group_vars/all.yml

nano complete-deployment.yml

mkdir -p templates
nano templates/deployment-report.j2

ansible-playbook -i inventory.ini complete-deployment.yml --tags "preparation,database"
ansible-playbook -i inventory.ini complete-deployment.yml
ansible-playbook -i inventory.ini complete-deployment.yml --tags "verification"

nano test-deployment.yml
ansible-playbook -i inventory.ini test-deployment.yml

# ------------------------------
# Troubleshooting / Validation (Ad-hoc Checks)
# ------------------------------
ansible database_servers -i inventory.ini -m systemd -a "name=mysqld" --become
ansible database_servers -i inventory.ini -m shell -a "tail -20 /var/log/mysqld.log" --become
ansible database_servers -i inventory.ini -m shell -a "mysql -u root -p'SecurePass123!' -e 'SHOW DATABASES;'" --become

ansible web_servers -i inventory.ini -m systemd -a "name=httpd" --become
ansible web_servers -i inventory.ini -m shell -a "tail -20 /var/log/httpd/error_log" --become
ansible web_servers -i inventory.ini -m shell -a "netstat -tlnp | grep :80" --become

ansible all -i inventory.ini -m shell -a "firewall-cmd --list-all" --become
ansible web_servers -i inventory.ini -m firewalld -a "port=80/tcp permanent=yes state=enabled immediate=yes" --become
