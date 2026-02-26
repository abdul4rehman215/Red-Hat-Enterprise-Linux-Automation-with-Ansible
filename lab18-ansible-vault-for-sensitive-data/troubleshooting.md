# 🛠️ troubleshooting Guide — Lab 18: Ansible Vault for Sensitive Data

> This file documents common Ansible Vault issues, their causes, and fixes.

---

## 1) ❌ ERROR: “Attempting to decrypt but no vault secrets found”

### ✅ Symptoms
Running a playbook that loads encrypted vars fails, for example:
```text
ERROR! Attempting to decrypt but no vault secrets found
File: /home/centos/ansible-vault-lab/vars/database_secrets.yml
````

### 🔍 Likely Causes

* You ran the playbook without:

  * `--ask-vault-pass`, or
  * `--vault-password-file`, or
  * `--vault-id ...`
* Vault password file path is wrong

### ✅ Fix

Run playbook with a vault secret method:

```bash id="l3t7iu"
ansible-playbook -i inventory/hosts playbooks/secure_deployment.yml --ask-vault-pass
```

Or use the vault password file:

```bash id="iu5zdf"
ansible-playbook -i inventory/hosts playbooks/secure_deployment.yml --vault-password-file .vault_password
```

---

## 2) ❌ Vault password file exists but playbook still fails

### ✅ Symptoms

* You are using `--vault-password-file`, but Ansible still prompts or fails.

### 🔍 Likely Causes

* Permissions too open (Ansible may warn or you may have security policy issues)
* Wrong file path (relative path problems)
* The vault file was rekeyed with a different password

### ✅ Fix

1. Confirm the file exists and permissions are strict:

```bash id="y74bw6"
ls -la .vault_password
```

Expected:

```text
-rw------- 1 centos centos ... .vault_password
```

2. Confirm your vault file decrypts using the password file:

```bash id="b4q4wr"
ansible-vault view vars/database_secrets.yml --vault-password-file .vault_password
```

3. If the vault password changed, rekey back to expected password:

```bash id="vvzpr0"
ansible-vault rekey vars/database_secrets.yml
```

---

## 3) ❌ YAML parsing errors inside a vault-created file

### ✅ Symptoms

* Playbook fails with YAML parsing errors after decrypting content
* `ansible-vault view` shows weird formatting or invalid YAML

### 🔍 Likely Causes

* Multiple keys entered on one line
* Broken indentation
* Key/value split incorrectly

### ✅ Fix

Edit the file using vault editor and correct YAML:

```bash id="u8str7"
ansible-vault edit vars/api_secrets.yml
```

Ensure format like:

```yaml
stripe_api_key: "sk_test_..."
paypal_client_secret: "..."
```

---

## 4) ❌ `vars/mixed_secrets.yml` shows “Not encrypted” in status checks

### ✅ Symptoms

Your loop prints:

```text
File: vars/mixed_secrets.yml
 Status: Not encrypted
```

### 🔍 Explanation (Expected Behavior)

This is expected because:

* Only a single variable is encrypted (`database_root_password: !vault | ...`)
* The file itself does not start with:

  * `$ANSIBLE_VAULT;...`

### ✅ Fix

No fix required.
If you want full-file encryption:

```bash id="4o2tfe"
ansible-vault encrypt vars/mixed_secrets.yml --vault-password-file .vault_password
```

---

## 5) ❌ `sed` replacement breaks YAML formatting for encrypted strings

### ✅ Symptoms

* `sed -i ...` replacement results in malformed YAML
* Extra quotes or missing newlines cause parsing failures

### 🔍 Likely Causes

* Injecting multi-line vault output into a quoted YAML string
* Escaping rules differ between shells

### ✅ Fix

Prefer manual insertion using a vault editor for multi-line encrypted blocks:

```bash id="w0ji24"
nano vars/mixed_secrets.yml
```

Or generate the encrypted string and paste carefully ensuring indentation:

```yaml
database_root_password: !vault |
  $ANSIBLE_VAULT;1.1;AES256
  ...
```

---

## 6) ❌ Rekeyed vault file can’t be decrypted anymore

### ✅ Symptoms

* After `ansible-vault rekey`, the old password doesn’t work
* Playbook that previously worked now fails to decrypt vars

### 🔍 Likely Causes

* Vault password was changed but automation still uses old `.vault_password`

### ✅ Fix

Update `.vault_password` to match new password **(never commit this file)**:

```bash id="udsvyr"
echo "NewVaultPassword456" > .vault_password
chmod 600 .vault_password
```

Or rekey vault back to the original password:

```bash id="m2tpqc"
ansible-vault rekey vars/database_secrets.yml
```

---

## 7) ❌ Encrypted values accidentally printed in logs/output

### ✅ Symptoms

* Sensitive data appears in Ansible output logs
* Someone used `debug: var=database_password`

### 🔍 Likely Causes

* Debugging without considering secret exposure
* Missing `no_log: true` on sensitive tasks

### ✅ Fix

1. Avoid printing secrets directly.
2. Use safe debug messages (show only status, lengths, or masked data).
3. Use `no_log: true` in tasks that handle secrets:

```yaml id="0tm9rq"
- name: Use secret safely
  some_module:
    password: "{{ database_password }}"
  no_log: true
```

---

## 8) ❌ Generated secret config files have weak permissions

### ✅ Symptoms

* `/tmp/app-config/*.conf` readable by other users

### 🔍 Likely Causes

* Wrong mode in template tasks
* Directory mode too open

### ✅ Fix

Ensure:

* directory is `0750`
* files are `0600`

Example (used in lab):

```yaml id="0x4uej"
- name: Create application configuration directory
  file:
    path: /tmp/app-config
    state: directory
    mode: '0750'

- name: Generate configuration
  template:
    src: ...
    dest: ...
    mode: '0600'
```

---

## 9) Quick Verification Checklist

### ✅ Check vault files are encrypted

```bash id="4gevjp"
head -n 1 vars/database_secrets.yml
```

Expected: `$ANSIBLE_VAULT;...`

### ✅ Test viewing with password file

```bash id="0frgwk"
ansible-vault view vars/database_secrets.yml --vault-password-file .vault_password
```

### ✅ Run playbook with vault password file

```bash id="s6h2k4"
ansible-playbook -i inventory/hosts playbooks/secure_deployment.yml --vault-password-file .vault_password
```

### ✅ Validate file permissions

```bash id="3xjk5m"
ls -la /tmp/app-config/
```

---

## 10) Recommended Repo Security (Important)

* Add `.vault_password` to `.gitignore`
* Never commit plaintext secrets
* Use environment-specific vault files in `group_vars/*/vault.yml`
* Prefer `ansible-vault create` over writing secrets plaintext first
