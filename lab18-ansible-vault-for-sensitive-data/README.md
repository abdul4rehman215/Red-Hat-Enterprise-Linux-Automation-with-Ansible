# 🔐 Lab 18: Ansible Vault for Sensitive Data

## 📌 Lab Summary
This lab focused on using **Ansible Vault** to securely manage sensitive data in automation projects. I created sample secret files, encrypted them using vault, learned how to view/edit/rekey vault files, and integrated encrypted variables into playbooks for secure deployments.

The lab also covered:
- Different ways to provide vault passwords (`--ask-vault-pass`, `--vault-password-file`)
- Encrypting full files vs encrypting individual values (`encrypt_string`)
- Environment-specific secret separation using `group_vars` + vault files
- A lightweight vault management helper script for daily vault operations

> ⚠️ Security Note (Portfolio Safety):  
> The lab content contains example credentials and secrets for demonstration. In real projects, secrets must **never** be committed in plain text. In this repository, vault files remain encrypted, and the vault password file should be **gitignored**.

---

## 🎯 Objectives
By the end of this lab, I was able to:

- Understand the importance of securing sensitive data in Ansible automation
- Create and manage encrypted files using Ansible Vault
- Encrypt passwords, API keys, and other sensitive information
- Integrate Ansible Vault into playbooks for secure task execution
- Use different methods to provide vault passwords during playbook execution
- Edit and view encrypted vault files
- Implement best practices for managing sensitive data in Ansible projects

---

## ✅ Prerequisites
To complete this lab, I needed:

- Basic understanding of Linux command line operations
- Familiarity with Ansible fundamentals (playbooks, tasks, variables)
- Knowledge of YAML syntax
- Understanding of file permissions and security concepts
- Completion of previous Ansible labs or equivalent experience

---

## 🧰 Lab Environment
**Environment Type:** Cloud lab environment (CentOS/RHEL-based)  
**OS:** CentOS/RHEL 8 (Ansible installed)  
**Ansible Version:** `ansible [core 2.13.13]`  
**Tools:** `ansible-vault`, `nano`, shell utilities

---

## ✅ What I Performed (Task Overview)

### ✅ Task 1: Vault Basics + Creating Sensitive Data
- Verified Ansible installation and created a structured lab directory.
- Created **plaintext sensitive variable files** for practice:
  - database credentials + API key + private key placeholder
  - user/admin credentials + encryption keys

### ✅ Task 2: Encrypting Files Using Vault
- Encrypted multiple files using:
  - `ansible-vault encrypt`
- Verified that encrypted files became unreadable using `cat`.
- Created a vault file directly using:
  - `ansible-vault create`

### ✅ Task 3: Viewing, Editing, and Rekeying Vault Files
- Viewed encrypted content without permanent decryption using:
  - `ansible-vault view`
- Updated vault content securely using:
  - `ansible-vault edit`
- Rotated vault password for an encrypted file using:
  - `ansible-vault rekey`

### ✅ Task 4: Integrating Vault into Playbooks
- Created a secure deployment playbook that loads encrypted variables using `vars_files`.
- Generated configuration files from templates using encrypted values.
- Created a Linux service user using an encrypted password hashed with `password_hash('sha512')`.
- Ran playbook securely using:
  - `--ask-vault-pass`
  - `--vault-password-file`

### ✅ Task 5: Advanced Vault Operations
- Permanently decrypted and re-encrypted a file using `decrypt` and `encrypt`.
- Encrypted a **single variable** using:
  - `ansible-vault encrypt_string`
- Created a **mixed** variable file: plain variables + one encrypted variable block.
- Practiced vault IDs with:
  - `--vault-id dev@prompt`
  - `--vault-id prod@prompt`

### ✅ Task 6: Best Practices — Environment Separation
- Built a secure directory structure using:
  - `group_vars/development/` + `vault.yml`
  - `group_vars/production/` + `vault.yml`
- Created environment-aware playbook to deploy different configs per environment.
- Verified output configuration files were generated correctly per environment.

### ✅ Task 7: Troubleshooting Vault Errors + Helper Script
- Simulated a vault failure by running a playbook without providing vault secrets.
- Validated vault file status (encrypted vs mixed).
- Created a helper script (`manage_vault.sh`) to automate common vault actions.

---

## 🧾 Repository Structure
```text
lab18-ansible-vault-for-sensitive-data/
├── README.md
├── commands.sh
├── output.txt
├── interview_qna.md
├── troubleshooting.md
├── manage_vault.sh
├── inventory/
│   └── hosts
├── playbooks/
│   ├── secure_deployment.yml
│   ├── environment_deployment.yml
│   └── test_vault_errors.yml
├── templates/
│   ├── database.conf.j2
│   ├── api.conf.j2
│   └── app_config.j2
├── vars/
│   ├── database_secrets.yml
│   ├── user_secrets.yml
│   ├── api_secrets.yml
│   ├── mixed_secrets.yml
│   ├── dev_secrets.yml
│   └── prod_secrets.yml
└── group_vars/
    ├── development/
    │   ├── main.yml
    │   └── vault.yml
    └── production/
        ├── main.yml
        └── vault.yml
````

---

## ✅ Verification Performed

* Confirmed encrypted files show `$ANSIBLE_VAULT;1.1;AES256` header.
* Successfully used `ansible-vault view` to inspect secrets securely.
* Confirmed vault edits persisted by re-viewing vault content.
* Verified playbook execution succeeded with vault password prompt and password file.
* Verified generated config files were created and locked down with strict permissions:

  * `/tmp/app-config/database.conf`
  * `/tmp/app-config/api.conf`
* Verified environment configs were generated:

  * `/tmp/development_config.conf`
  * `/tmp/production_config.conf`
* Confirmed vault error appears when running without vault secrets:

  * `ERROR! Attempting to decrypt but no vault secrets found`

---

## 🔐 Security Relevance (Strong)

This lab has **direct security relevance** because it addresses:

* Secret sprawl prevention (no plain text passwords in playbooks)
* Safe team collaboration (share automation without exposing secrets)
* Compliance alignment (encrypted sensitive data handling)
* Password management workflows (vault rotation + rekey)
* Environment isolation (dev/prod secrets separated cleanly)

---

## 🧠 What I Learned

* How to encrypt and manage sensitive variables in Ansible safely
* How to securely integrate encrypted data into playbooks
* How to encrypt full files vs encrypt individual variables
* How to manage secrets per environment using `group_vars` + encrypted vault files
* How to prevent common vault mistakes (missing vault secret, invalid YAML, permissions)
* How to automate vault operations with a small helper script

---

## 🌍 Why This Matters

In production automation, it’s easy to leak secrets through:

* plaintext YAML variable files
* accidentally committed `.env` or password files
* logs and debug output

Ansible Vault provides a practical approach to keeping automation reusable **without exposing** credentials. This is foundational for secure DevOps and infrastructure automation.

---

## 🧩 Real-World Applications

* Securing DB credentials for automated deployments
* Encrypting API keys for cloud automation
* Protecting SSH private keys or certificate secrets in IaC pipelines
* Implementing secure separation of dev/prod environments
* Supporting compliance requirements where encryption is mandatory

---

## ✅ Result

* ✅ Vault files successfully created and encrypted
* ✅ Secrets viewed/edited securely without plaintext persistence
* ✅ Vault password rotated using `rekey`
* ✅ Secure deployment playbook executed with encrypted vars
* ✅ Environment-specific deployment validated for dev + production
* ✅ Vault troubleshooting scenarios tested and resolved
* ✅ Helper vault management script created and tested

---

## 🏁 Conclusion

This lab provided hands-on experience with **Ansible Vault**, covering the full lifecycle of secret management: creation, encryption, viewing, editing, rotation, integration into playbooks, and best practices for structured environment handling.

I can now build automation workflows that remain secure even when shared across teams or stored in version control, without exposing sensitive credentials.
