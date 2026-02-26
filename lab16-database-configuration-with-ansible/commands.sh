#!/bin/bash
# Lab 16 - Database Configuration with Ansible (MySQL + PostgreSQL)
# Commands Executed During Lab (sequential, no explanations)

# --- Verify Ansible installation ---
ansible --version

# --- Verify connectivity to target hosts (default inventory) ---
ansible all -m ping

# --- Create lab project directory and structure ---
mkdir -p ~/ansible-database-lab
cd ~/ansible-database-lab
mkdir -p {playbooks,roles,group_vars,host_vars,files,templates}

# --- Create inventory ---
nano inventory.ini

# --- Validate inventory structure ---
ansible-inventory -i inventory.ini --list

# --- Test group connectivity ---
ansible mysql_servers -i inventory.ini -m ping
ansible postgresql_servers -i inventory.ini -m ping

# --- Create MySQL setup playbook ---
nano playbooks/mysql-setup.yml

# --- Check required collections (if any) ---
ansible-galaxy collection list | egrep 'community\.mysql|community\.general|community\.postgresql' || true

# --- Install required Ansible collections ---
ansible-galaxy collection install community.mysql community.postgresql community.general

# --- Create MySQL template ---
mkdir -p templates
nano templates/my.cnf.j2

# --- Run MySQL setup ---
ansible-playbook -i inventory.ini playbooks/mysql-setup.yml

# --- Verify MySQL service ---
ansible mysql_servers -i inventory.ini -m shell -a "systemctl status mysql" --become

# --- Verify MySQL databases ---
ansible mysql_servers -i inventory.ini -m shell -a "mysql -u root -p'SecureRootPass123!' -e 'SHOW DATABASES;'" --become

# --- Create PostgreSQL setup playbook ---
nano playbooks/postgresql-setup.yml

# --- Run PostgreSQL setup ---
ansible-playbook -i inventory.ini playbooks/postgresql-setup.yml

# --- Verify PostgreSQL service (wrapper service on Ubuntu) ---
ansible postgresql_servers -i inventory.ini -m shell -a "systemctl status postgresql" --become

# --- Verify PostgreSQL databases ---
ansible postgresql_servers -i inventory.ini -m shell -a "sudo -u postgres psql -c '\l'" --become

# --- Create security hardening playbook ---
nano playbooks/database-security.yml

# --- Run security hardening ---
ansible-playbook -i inventory.ini playbooks/database-security.yml

# --- Verify fail2ban status ---
ansible database_servers -i inventory.ini -m shell -a "systemctl status fail2ban" --become

# --- Verify MySQL security settings ---
ansible mysql_servers -i inventory.ini -m shell -a "grep -E '(local-infile|skip-show-database)' /etc/mysql/mysql.conf.d/mysqld.cnf" --become

# --- Verify PostgreSQL security setting ---
ansible postgresql_servers -i inventory.ini -m shell -a "sudo -u postgres psql -c 'SHOW log_connections;'" --become

# --- Create database backup playbook ---
nano playbooks/database-backup.yml

# --- Run backup configuration ---
ansible-playbook -i inventory.ini playbooks/database-backup.yml

# --- Test backup scripts manually ---
ansible mysql_servers -i inventory.ini -m shell -a "/usr/local/bin/mysql-backup.sh" --become
ansible postgresql_servers -i inventory.ini -m shell -a "/usr/local/bin/postgresql-backup.sh" --become

# --- Verify backup files ---
ansible database_servers -i inventory.ini -m shell -a "ls -la /opt/database-backups/" --become

# --- Create monitoring playbook ---
nano playbooks/database-monitoring.yml

# --- Run monitoring setup ---
ansible-playbook -i inventory.ini playbooks/database-monitoring.yml

# --- Test monitoring scripts ---
ansible database_servers -i inventory.ini -m shell -a "/usr/local/bin/db-health-check.sh" --become
ansible mysql_servers -i inventory.ini -m shell -a "/usr/local/bin/mysql-status.sh" --become
ansible postgresql_servers -i inventory.ini -m shell -a "/usr/local/bin/postgresql-status.sh" --become

# --- Create role structure ---
mkdir -p roles/database-management/{tasks,handlers,templates,vars,defaults,files,meta}

# --- Role metadata ---
nano roles/database-management/meta/main.yml

# --- Role defaults ---
nano roles/database-management/defaults/main.yml

# --- Role main tasks ---
nano roles/database-management/tasks/main.yml

# --- Role task files ---
nano roles/database-management/tasks/mysql.yml
nano roles/database-management/tasks/postgresql.yml
nano roles/database-management/tasks/security.yml
nano roles/database-management/tasks/backup.yml
nano roles/database-management/tasks/monitoring.yml

# --- Role templates ---
nano roles/database-management/templates/mysqld.cnf.j2
nano roles/database-management/templates/mysql-backup.sh.j2
nano roles/database-management/templates/postgresql-backup.sh.j2
nano roles/database-management/templates/db-monitor.sh.j2

# --- Role handlers ---
nano roles/database-management/handlers/main.yml

# --- Role test playbooks ---
nano playbooks/use-role-mysql.yml
nano playbooks/use-role-postgresql.yml

# --- Run role playbooks ---
ansible-playbook -i inventory.ini playbooks/use-role-mysql.yml
ansible-playbook -i inventory.ini playbooks/use-role-postgresql.yml

# --- Validate role outputs (monitor script) ---
ansible database_servers -i inventory.ini -m shell -a "/usr/local/bin/db-monitor.sh | head -25" --become
