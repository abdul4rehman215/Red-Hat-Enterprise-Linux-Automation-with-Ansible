#!/bin/bash
# Lab 15 - Configuring Web Servers with Ansible (Apache)
# Commands Executed During Lab (sequential, no explanations)

# --- Verify Ansible installation ---
ansible --version

# --- Verify Ansible configuration ---
ansible-config view

# --- Create project directory structure ---
mkdir ~/ansible-webserver-lab
cd ~/ansible-webserver-lab
mkdir playbooks
mkdir inventory
mkdir templates
mkdir files

# --- Create inventory file ---
nano inventory/hosts.ini

# --- Test connectivity to all hosts ---
ansible -i inventory/hosts.ini all -m ping

# --- Test connectivity to webservers group ---
ansible -i inventory/hosts.ini webservers -m ping

# --- Create Apache installation/configuration playbook ---
nano playbooks/install-apache.yml

# --- Run Apache installation/configuration playbook ---
ansible-playbook -i inventory/hosts.ini playbooks/install-apache.yml

# --- Run playbook using tags only (selective run) ---
ansible-playbook -i inventory/hosts.ini playbooks/install-apache.yml --tags "install,configure"

# --- Run playbook in check mode (dry run) ---
ansible-playbook -i inventory/hosts.ini playbooks/install-apache.yml --check

# --- Create website template and static files ---
nano templates/index.html.j2
nano files/style.css

# --- Create website deployment playbook ---
nano playbooks/deploy-website.yml

# --- Deploy website content ---
ansible-playbook -i inventory/hosts.ini playbooks/deploy-website.yml

# --- Verify deployment with verbose output (verify tasks only) ---
ansible-playbook -i inventory/hosts.ini playbooks/deploy-website.yml -v --tags verify

# --- Create master end-to-end playbook ---
nano playbooks/complete-webserver-setup.yml

# --- Create Apache configuration template ---
nano templates/httpd.conf.j2

# --- Create included content deployment tasks file ---
nano playbooks/deploy-content.yml

# --- Run complete deployment playbook ---
ansible-playbook -i inventory/hosts.ini playbooks/complete-webserver-setup.yml

# --- Run complete deployment with verbosity for troubleshooting ---
ansible-playbook -i inventory/hosts.ini playbooks/complete-webserver-setup.yml -vv

# --- Verification tests (manual/ad-hoc) ---
ansible -i inventory/hosts.ini webservers -m uri -a "url=http://192.168.1.10 method=GET"
ansible -i inventory/hosts.ini webservers -m uri -a "url=http://{{ ansible_host }} method=GET"

ansible -i inventory/hosts.ini webservers -m systemd -a "name=httpd" --become

ansible -i inventory/hosts.ini webservers -m shell -a "netstat -tlnp | grep :80"
ansible -i inventory/hosts.ini webservers -m yum -a "name=net-tools state=present" --become
ansible -i inventory/hosts.ini webservers -m shell -a "netstat -tlnp | grep :80"

curl http://192.168.1.10
curl http://192.168.1.11

# --- Create verification playbook ---
nano playbooks/verify-deployment.yml

# --- Run verification playbook ---
ansible-playbook -i inventory/hosts.ini playbooks/verify-deployment.yml

# --- Troubleshooting: SSH manual test / agent checks ---
ssh -i ~/.ssh/id_rsa ec2-user@192.168.1.10
ssh-add -l
ssh-add ~/.ssh/id_rsa

# --- Troubleshooting: sudo access validation ---
ansible -i inventory/hosts.ini webservers -m shell -a "sudo whoami"
cat inventory/hosts.ini

# --- Troubleshooting: firewall rules check/open HTTP if needed ---
ansible -i inventory/hosts.ini webservers -m shell -a "firewall-cmd --list-all" --become
ansible -i inventory/hosts.ini webservers -m firewalld -a "service=http permanent=yes state=enabled immediate=yes" --become

# --- Troubleshooting: Apache config test and logs ---
ansible -i inventory/hosts.ini webservers -m shell -a "httpd -t" --become
ansible -i inventory/hosts.ini webservers -m shell -a "tail -20 /var/log/httpd/error_log" --become
