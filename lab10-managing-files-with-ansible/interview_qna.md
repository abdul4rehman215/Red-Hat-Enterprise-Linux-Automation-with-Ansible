# 🎤 Lab 10: Managing Files with Ansible — Interview Q&A

## 1) What is the difference between static and dynamic file management in Ansible?
- **Static file management** deploys files that do not change per host (or change very little), using modules like `copy`.
- **Dynamic file management** generates files per host/environment using variables and facts, typically using the `template` module with Jinja2.

---

## 2) When should you use the `copy` module?
Use `copy` when:
- the file is static (same content for all hosts)
- you want to copy a file from the control node to the managed node
- you want to deploy inline content directly into a file using `content:`

This lab used `copy` for:
- `apache-security.conf`
- inline `index.html`
- a placeholder `favicon.ico`

---

## 3) When should you use the `template` module?
Use `template` when:
- the file should be generated dynamically per host
- the configuration depends on variables, host facts, or environment settings
- you need conditional blocks, loops, or filters

This lab used `template` for:
- Apache virtual host configs
- system info configuration file
- dynamic HTML index page
- conditional test template

---

## 4) What does `backup: yes` do in copy/template tasks?
It creates a backup copy of the destination file before overwriting it.  
This is useful for:
- rollback
- auditing changes
- troubleshooting configuration regressions

---

## 5) What does the `validate` parameter do, and why is it important?
`validate` runs a command on the temporary file before replacing the destination file.
If validation fails, the file is not deployed.

Example used:
- `validate: "httpd -t -f %s"`

This prevents pushing a broken Apache config that could stop the web server.

---

## 6) Why use `group_vars` and `host_vars` for template deployments?
They allow structured configuration:
- `group_vars/webservers.yml` → shared defaults for the web server group
- `host_vars/web1.yml`, `host_vars/web2.yml` → host-specific overrides (server_name, aliases, document root, max connections)

This approach scales well for fleets.

---

## 7) How did you customize the virtual host configuration per host?
By using:
- `server_name` and `server_aliases` in host_vars
- `document_root` set differently for web1 and web2
- conditionals in the template (primary vs secondary) using `ansible_hostname`

---

## 8) What kinds of Jinja2 logic were used in the templates?
This lab used:
- `if` conditions (`{% if ... %}`)
- loops (`{% for ... %}`)
- filters (`| default`, `| upper`, `| lower`, `| title`)
- checks for variable existence (`is defined`)

---

## 9) Why did the advanced playbook fail at the `chattr +i` step?
Some environments (especially virtualized or overlay filesystems) restrict immutable flags.
The playbook showed:
- `chattr: Operation not permitted while setting flags on /opt/app/config`

This is a common real-world constraint depending on filesystem and virtualization.

---

## 10) What does the `archive` module do in the handler?
It packages the `/opt/app/config` directory into a compressed archive:
- `/backup/config-backup-<timestamp>.tar.gz`

This creates a backup snapshot after configuration deployment.

---

## 11) What is the purpose of the testing playbook (`test-file-management.yml`)?
It validates multiple scenarios:
- downloading a file via `get_url`
- generating content via `copy`
- rendering templates with conditionals
- generating multiple files in loops
- verifying artifacts using `find`

This makes file management behavior testable and repeatable.

---

## 12) Why did you run `ansible-playbook --syntax-check`?
To confirm playbook YAML and Ansible structure are valid **before** execution.
It’s a fast way to detect YAML errors, indentation issues, and basic playbook structure problems.

---

## 13) What happened when you tried installing `ansible-lint`?
`ansible-lint` was not installed by default, and the repository did not have a matching package available:
- `No match for argument: ansible-lint`
This is realistic in minimal lab images, so syntax-check remained the main validation tool.

---

## 14) How did you verify files were deployed successfully?
Verification included:
- checking file presence and permissions using ad-hoc Ansible shell tasks:
  - `/etc/httpd/conf.d/`
  - `/etc/system-info.conf`
  - `/opt/app/config/*`
- confirming template output correctness by reading generated files
- confirming test files exist under `/tmp`

---

## 15) What real-world scenario does this lab represent?
This lab represents configuration management workflows where:
- security baselines and static configs are pushed reliably
- dynamic per-host configurations are generated using templates
- backups and validation are enforced
- testing playbooks confirm correctness after automation runs
