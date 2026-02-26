#!/bin/bash
# Lab 18 - Ansible Vault for Sensitive Data
# Commands Executed During Lab (Sequential)

# -----------------------------
# Task 1.1 - Verify Ansible + Setup Lab Directory
# -----------------------------

ansible --version
mkdir -p ~/ansible-vault-lab
cd ~/ansible-vault-lab
mkdir -p {playbooks,vars,inventory}
ls -l

# -----------------------------
# Task 1.2 - Create Sample Sensitive Data (Plaintext)
# -----------------------------

nano vars/database_secrets.yml
nano vars/user_secrets.yml

# -----------------------------
# Task 1.3 - View Unencrypted Files
# -----------------------------

echo "=== Database Secrets (UNENCRYPTED) ==="
cat vars/database_secrets.yml
echo -e "\n=== User Secrets (UNENCRYPTED) ==="
cat vars/user_secrets.yml

# -----------------------------
# Task 2.1 - Encrypt Files with Ansible Vault
# -----------------------------

ansible-vault encrypt vars/database_secrets.yml
ansible-vault encrypt vars/user_secrets.yml

# -----------------------------
# Task 2.2 - Verify Encryption (Show Vault Header)
# -----------------------------

echo "=== Encrypted Database Secrets ==="
cat vars/database_secrets.yml
echo -e "\n=== Encrypted User Secrets ==="
cat vars/user_secrets.yml

# -----------------------------
# Task 2.3 - Create Encrypted File Directly
# -----------------------------

ansible-vault create vars/api_secrets.yml

# -----------------------------
# Task 3.1 - View Encrypted Files
# -----------------------------

ansible-vault view vars/database_secrets.yml
ansible-vault view vars/user_secrets.yml
ansible-vault view vars/api_secrets.yml

# -----------------------------
# Task 3.2 - Edit Encrypted Files
# -----------------------------

ansible-vault edit vars/database_secrets.yml
ansible-vault view vars/database_secrets.yml

# -----------------------------
# Task 3.3 - Change Vault Password (Rekey)
# -----------------------------

ansible-vault rekey vars/database_secrets.yml

# -----------------------------
# Task 4.1 - Create Inventory
# -----------------------------

nano inventory/hosts

# -----------------------------
# Task 4.2 - Create Playbook Using Vault Variables
# -----------------------------

nano playbooks/secure_deployment.yml

# -----------------------------
# Task 4.3 - Create Template Files
# -----------------------------

mkdir -p templates
nano templates/database.conf.j2
nano templates/api.conf.j2

# -----------------------------
# Task 4.4 - Run Playbook with Vault Password
# -----------------------------

# Rekey back to original password
ansible-vault rekey vars/database_secrets.yml

# Run with vault prompt
ansible-playbook -i inventory/hosts playbooks/secure_deployment.yml --ask-vault-pass

# -----------------------------
# Task 4.5 - Use Vault Password File
# -----------------------------

echo "VaultPassword123" > .vault_password
chmod 600 .vault_password
ls -la .vault_password
ansible-playbook -i inventory/hosts playbooks/secure_deployment.yml --vault-password-file .vault_password

# -----------------------------
# Task 4.6 - Verify Deployment Results
# -----------------------------

echo "=== Database Configuration ==="
sudo cat /tmp/app-config/database.conf
echo -e "\n=== API Configuration ==="
sudo cat /tmp/app-config/api.conf
echo -e "\n=== Service User Information ==="
id appservice
echo -e "\n=== Directory Permissions ==="
ls -la /tmp/app-config/

# -----------------------------
# Task 5.1 - Decrypt Files Permanently (Backup + Decrypt + Re-encrypt)
# -----------------------------

cp vars/user_secrets.yml vars/user_secrets.yml.backup
ls -la vars/user_secrets.yml vars/user_secrets.yml.backup
ansible-vault decrypt vars/user_secrets.yml --vault-password-file .vault_password
cat vars/user_secrets.yml
ansible-vault encrypt vars/user_secrets.yml --vault-password-file .vault_password

# -----------------------------
# Task 5.2 - Encrypt Specific Variables
# -----------------------------

ansible-vault encrypt_string 'SuperSecretPassword123!' --name 'mysql_root_password' --vault-password-file .vault_password

# -----------------------------
# Task 5.3 - Create Mixed Variable File (Plain + One Encrypted Var)
# -----------------------------

nano vars/mixed_secrets.yml
encrypted_password=$(ansible-vault encrypt_string 'RootPassword789!' --name 'database_root_password' --vault-password-file .vault_password)
sed -i 's/database_root_password: "PLACEHOLDER"/'"$encrypted_password"'/' vars/mixed_secrets.yml
cat vars/mixed_secrets.yml

# -----------------------------
# Task 5.4 - Multiple Vault IDs (Dev/Prod)
# -----------------------------

ansible-vault create --vault-id dev@prompt vars/dev_secrets.yml
ansible-vault create --vault-id prod@prompt vars/prod_secrets.yml

# -----------------------------
# Task 6.1 - Best Practices: Secure Structure
# -----------------------------

mkdir -p {group_vars,host_vars}
mkdir -p group_vars/{development,production}
nano group_vars/development/main.yml
ansible-vault create group_vars/development/vault.yml --vault-password-file .vault_password

# -----------------------------
# Task 6.2 - Production Configuration
# -----------------------------

nano group_vars/production/main.yml
ansible-vault create group_vars/production/vault.yml --vault-password-file .vault_password

# -----------------------------
# Task 6.3 - Environment-Aware Playbook + Template
# -----------------------------

nano playbooks/environment_deployment.yml
nano templates/app_config.j2

# -----------------------------
# Task 6.5 - Update Inventory + Test Dev/Prod Deployments
# -----------------------------

nano inventory/hosts

ansible-playbook -i inventory/hosts playbooks/environment_deployment.yml \
 --limit development \
 --vault-password-file .vault_password

ansible-playbook -i inventory/hosts playbooks/environment_deployment.yml \
 --limit production \
 --vault-password-file .vault_password

# -----------------------------
# Task 6.6 - Verify Environment Configurations
# -----------------------------

echo "=== Development Configuration ==="
sudo cat /tmp/development_config.conf
echo -e "\n=== Production Configuration ==="
sudo cat /tmp/production_config.conf

# -----------------------------
# Task 7.1 - Vault Errors Test
# -----------------------------

nano playbooks/test_vault_errors.yml
echo "=== Testing without vault password (should fail) ==="
ansible-playbook -i inventory/hosts playbooks/test_vault_errors.yml || echo "Expected failure occurred"
echo -e "\n=== Running with correct vault password ==="
ansible-playbook -i inventory/hosts playbooks/test_vault_errors.yml --vault-password-file .vault_password

# -----------------------------
# Task 7.2 - Vault File Validation Loop
# -----------------------------

echo "=== Checking vault file status ==="
for file in vars/*.yml group_vars/*/vault.yml; do
 if [ -f "$file" ]; then
  echo "File: $file"
  if head -1 "$file" | grep -q "ANSIBLE_VAULT"; then
   echo " Status: Encrypted ✓"
  else
   echo " Status: Not encrypted "
  fi
  echo
 fi
done

# -----------------------------
# Task 7.3 - Vault Management Script
# -----------------------------

nano manage_vault.sh
chmod +x manage_vault.sh
./manage_vault.sh status
