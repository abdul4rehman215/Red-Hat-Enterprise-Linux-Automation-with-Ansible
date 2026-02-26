#!/bin/bash
# Lab 17 - Orchestrating Multiple Tasks
# Commands Executed During Lab (Sequential)

# -----------------------------
# Task 1.1 - Project Structure
# -----------------------------

mkdir -p ~/ansible-orchestration
cd ~/ansible-orchestration
mkdir -p {playbooks,roles,group_vars,host_vars,inventory}
ls -l

# -----------------------------
# Task 1.2 - Create Master Playbook
# -----------------------------

nano playbooks/site.yml

# -----------------------------
# Task 1.3 - Create Component Playbooks
# -----------------------------

nano playbooks/database.yml
nano playbooks/webservers.yml

# -----------------------------
# Task 1.4 - Create Templates
# -----------------------------

mkdir -p templates
nano templates/app_config.php.j2
nano templates/webapp.conf.j2

# -----------------------------
# Task 2.1 - Dependency Validation Playbook
# -----------------------------

nano playbooks/dependency_check.yml

# -----------------------------
# Task 2.2 - Load Balancer Playbook
# -----------------------------

nano playbooks/loadbalancer.yml

# -----------------------------
# Task 2.3 - HAProxy Template
# -----------------------------

nano templates/haproxy.cfg.j2

# -----------------------------
# Task 2.4 - Monitoring + Validation Playbook
# -----------------------------

nano playbooks/monitoring.yml

# -----------------------------
# Task 2.5 - Inventory
# -----------------------------

nano inventory/hosts

# -----------------------------
# Task 2.6 - Group Variables
# -----------------------------

nano group_vars/all.yml

# -----------------------------
# Task 2.7 - Execute Orchestration
# -----------------------------

ansible-playbook -i inventory/hosts playbooks/dependency_check.yml
ansible-playbook -i inventory/hosts playbooks/site.yml

# Run specific phases if needed
ansible-playbook -i inventory/hosts playbooks/site.yml --tags database
ansible-playbook -i inventory/hosts playbooks/site.yml --tags webservers
ansible-playbook -i inventory/hosts playbooks/site.yml --tags loadbalancer

# -----------------------------
# Task 2.8 - Rollback Playbook
# -----------------------------

nano playbooks/rollback.yml

# -----------------------------
# Troubleshooting Commands
# -----------------------------

ansible database_servers -i inventory/hosts -m systemd -a "name=mariadb" --become
ansible database_servers -i inventory/hosts -m mysql_db -a "name=webapp_db state=present login_unix_socket=/var/lib/mysql/mysql.sock" --become

ansible web_servers -i inventory/hosts -m shell -a "systemctl status httpd && tail -10 /var/log/httpd/error_log" --become

ansible load_balancer -i inventory/hosts -m shell -a "haproxy -c -f /etc/haproxy/haproxy.cfg && systemctl status haproxy" --become

ansible all -i inventory/hosts -m shell -a "firewall-cmd --list-all" --become

ansible-playbook -i inventory/hosts playbooks/site.yml -vvv
ansible all -i inventory/hosts -m setup
ansible all -i inventory/hosts -m ping
ansible all -i inventory/hosts -m shell -a "systemctl status httpd mariadb haproxy" --become
