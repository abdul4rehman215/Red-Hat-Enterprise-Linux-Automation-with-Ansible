#!/bin/bash
# Lab 20 - Optimizing Playbooks and Performance
# Commands Executed During Lab (Sequential)

# -----------------------------
# Task 1.1 - Navigate Lab Directory + Review Monolithic Playbook
# -----------------------------

cd /home/ansible/lab20
ls -la
cat large-playbook.yml

# -----------------------------
# Task 1.2 - Create Role Directory Structure
# -----------------------------

mkdir -p roles/{webserver,database,application,monitoring,security}/{tasks,handlers,templates,files,vars,defaults,meta}
tree roles/

# -----------------------------
# Task 1.3 - Webserver Role
# -----------------------------

nano roles/webserver/tasks/main.yml
nano roles/webserver/defaults/main.yml
nano roles/webserver/handlers/main.yml
nano roles/webserver/templates/httpd.conf.j2

# -----------------------------
# Task 1.4 - Database Role
# -----------------------------

nano roles/database/tasks/main.yml
nano roles/database/defaults/main.yml
nano roles/database/handlers/main.yml
nano roles/database/templates/my.cnf.j2

# -----------------------------
# Task 1.5 - Application Role (+ sample app files)
# -----------------------------

nano roles/application/tasks/main.yml
nano roles/application/defaults/main.yml
nano index.php
nano style.css
nano roles/application/templates/app-config.php.j2

# -----------------------------
# Task 1.6 - Optimized Playbook + Minimal Missing Roles
# -----------------------------

nano optimized-playbook.yml
nano roles/security/tasks/main.yml
nano roles/monitoring/tasks/main.yml

nano site.yml

# -----------------------------
# Task 2.1 - Async Optimization Playbook
# -----------------------------

nano async-optimization.yml

# -----------------------------
# Task 2.2 - Delegation Optimization Playbook (+ handlers fix)
# -----------------------------

nano delegation-optimization.yml
sed -n '1,200p' delegation-optimization.yml
nano delegation-optimization.yml

# -----------------------------
# Task 2.3 - Parallel Optimization Playbook
# -----------------------------

nano parallel-optimization.yml

# -----------------------------
# Task 3.1 - Performance Testing Framework + Templates
# -----------------------------

nano performance-test.yml
nano run-performance-test.yml
nano performance-report.j2

# -----------------------------
# Task 3.2 - Large Inventory + ansible.cfg Tuning
# -----------------------------

nano large-inventory
nano ansible.cfg

# -----------------------------
# Task 3.3 - Performance Monitoring + Fork Comparison
# -----------------------------

nano monitor-performance.yml
nano fork-performance-test.yml
nano fork-comparison-report.j2

# -----------------------------
# Task 3.4 - Benchmarking Script
# -----------------------------

nano benchmark-playbooks.sh
chmod +x benchmark-playbooks.sh
./benchmark-playbooks.sh

# -----------------------------
# Task 3.5 - Performance Analysis Playbook
# -----------------------------

nano analyze-performance.yml
ansible-playbook analyze-performance.yml

# -----------------------------
# Troubleshooting Note - Role Dependencies
# -----------------------------

nano roles/application/meta/main.yml
