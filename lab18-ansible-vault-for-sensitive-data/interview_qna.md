# 🎤 interview_qna.md — Lab 18: Ansible Vault for Sensitive Data

## 1) What problem does Ansible Vault solve?
**Answer:**  
Ansible Vault protects sensitive information (passwords, API keys, private keys, tokens) by encrypting data so it can be stored in a repo without being readable in plain text.

---

## 2) What does an encrypted vault file look like?
**Answer:**  
A vault-encrypted file starts with a header like:
```text
$ANSIBLE_VAULT;1.1;AES256
````

Then it contains encrypted blocks of text that are unreadable without the vault password.

---

## 3) What is the difference between `ansible-vault encrypt` and `ansible-vault create`?

**Answer:**

* `ansible-vault encrypt <file>` encrypts an existing plaintext file.
* `ansible-vault create <file>` creates a new file directly in encrypted form, so secrets never exist as a saved plaintext file (best practice).

---

## 4) How can you view encrypted secrets without permanently decrypting files?

**Answer:**
Use:

```bash
ansible-vault view vars/database_secrets.yml
```

This decrypts content temporarily for viewing and does not change the file on disk.

---

## 5) How can you edit an encrypted vault file safely?

**Answer:**
Use:

```bash
ansible-vault edit vars/database_secrets.yml
```

It decrypts into a temporary buffer for editing and re-encrypts automatically after saving.

---

## 6) What does `ansible-vault rekey` do?

**Answer:**
It changes the vault password (re-encrypts the file using a new password). This is useful for password rotation or when access needs to be updated.

---

## 7) What are the common ways to provide vault passwords during playbook runs?

**Answer:**

* Interactive prompt:

```bash
ansible-playbook play.yml --ask-vault-pass
```

* Password file:

```bash
ansible-playbook play.yml --vault-password-file .vault_password
```

* Vault IDs (for multiple vault passwords):

```bash
ansible-playbook play.yml --vault-id dev@prompt --vault-id prod@prompt
```

---

## 8) Why must `.vault_password` never be committed to Git?

**Answer:**
Because it allows anyone with the repo to decrypt vault files. Even if files are encrypted, storing the password in Git breaks the entire security model.

---

## 9) What is `ansible-vault encrypt_string` used for?

**Answer:**
It encrypts a single secret value (not the whole file). This is useful when you want a file to remain mostly readable but protect a specific variable.

Example:

```bash
ansible-vault encrypt_string 'RootPassword789!' --name 'database_root_password'
```

---

## 10) Why did `vars/mixed_secrets.yml` show “Not encrypted” in the status check?

**Answer:**
Because only one variable inside the file was encrypted. The file itself does not start with the `$ANSIBLE_VAULT` header, so it’s not a fully-encrypted vault file.

---

## 11) How did we securely integrate vault variables into a playbook?

**Answer:**
By loading encrypted vars using `vars_files`:

```yaml
vars_files:
  - ../vars/database_secrets.yml
  - ../vars/user_secrets.yml
  - ../vars/api_secrets.yml
```

Then templates and tasks can reference these variables safely.

---

## 12) What is the security benefit of setting strict permissions like `0600` for generated config files?

**Answer:**
It ensures only root (or the file owner) can read/write the secrets inside. This reduces the risk of local privilege exposure where other users could read secret configs.

---

## 13) Why is it recommended to separate secrets by environment (dev vs prod)?

**Answer:**
Because dev and prod have different risk levels and access control needs. Separating secrets limits blast radius, prevents accidental production credential usage in dev, and supports safer automation workflows.

---

## 14) What is a “vault ID” and why is it useful?

**Answer:**
Vault IDs allow using different vault passwords for different secret domains (e.g., dev vs prod). This supports better access control and reduces the risk of “one password unlocks everything.”

---

## 15) What error occurs when running a vault-protected playbook without providing vault secrets?

**Answer:**
Example error:

```text
ERROR! Attempting to decrypt but no vault secrets found
```

Fix by using `--ask-vault-pass` or `--vault-password-file`.
