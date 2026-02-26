# 🎤 Lab 08: Writing Complex Playbooks — Interview Q&A

## 1) What makes a playbook “complex” in Ansible?
A playbook becomes complex when it needs to manage **multiple hosts/groups**, deploy **multi-tier services** (web + database), handle **dependencies**, and include **verification, templating, handlers, and variable management**. Complexity also increases when you need modularity, reusability, and scaling across environments.

---

## 2) Why use multiple plays in a single playbook?
Multiple plays allow you to **separate concerns** and execute automation in logical stages, such as:
- configuring database servers first
- configuring web servers next
- deploying the application last
This improves readability, troubleshooting, and makes the automation easier to maintain.

---

## 3) What are Ansible roles and why are they useful?
Roles are a structured way to package automation into reusable components. They help by:
- enforcing a standard directory structure
- separating tasks, templates, handlers, defaults, and vars
- allowing reuse across projects and environments
Roles make playbooks cleaner and more scalable.

---

## 4) How did roles improve the architecture in this lab?
Instead of having everything inside `site.yml`, the configuration was modularized into:
- `mysql` role (database installation + config + firewall)
- `apache` role (web server setup + vhost template + firewall)
- `webapp` role (application templates and deployment)
This makes the playbook easier to extend and maintain.

---

## 5) What is the purpose of `group_vars/`?
`group_vars/` stores variables per inventory group so different host groups can have different settings.  
In this lab:
- `database_servers.yml` stored MySQL configuration and credentials
- `web_servers.yml` stored Apache/app settings
- `all.yml` stored common settings like timezone and NTP servers

---

## 6) What are handlers in Ansible and where did you use them?
Handlers run when notified, typically to restart services only if configuration changes occur.  
In this lab:
- MySQL handler restarted `mysqld` when the root password or config template changed
- Apache handler restarted `httpd` when the virtual host config changed

---

## 7) What is the difference between `template` and `copy` modules?
- `copy` transfers static files or inline content directly as-is.
- `template` renders Jinja2 templates (`.j2`) with variables before transferring.
In this lab, templates were used for:
- `my.cnf.j2` (MySQL config)
- `vhost.conf.j2` (Apache vhost)
- PHP files (config + index + dbtest)
- `deployment-report.j2` (report generation)

---

## 8) Why did you run `--check` before actual deployment?
`--check` mode performs a dry run to validate:
- syntax correctness
- task reachability
- what changes would occur
It reduces risk and helps catch errors before touching production systems.

---

## 9) What are tags and how were they used here?
Tags allow running specific parts of a playbook without running everything.  
Examples from this lab:
- `--tags "preparation,database"` ran only system preparation + database configuration
- `--tags "verification"` ran only the post-deployment verification tasks

---

## 10) What are pre_tasks and post_tasks used for?
- `pre_tasks` run before roles/tasks for preparation checks (disk space, package availability).
- `post_tasks` run after role execution for validation steps (service checks, HTTP test).
This approach builds reliable automation with built-in checks and reporting.

---

## 11) How did you validate the web application deployment?
Validation included:
- verifying Apache service status (`systemd`)
- checking port 80 listening (`netstat`)
- testing application endpoint using `uri` module
- validating database connectivity through `dbtest.php`

---

## 12) Why was firewall configuration included in roles?
Firewall rules are part of infrastructure configuration and should be automated for consistency.  
In this lab:
- Web servers opened `http` and `https`
- Database servers opened `3306/tcp` for MySQL
This ensures services are reachable without manual configuration.

---

## 13) What is the purpose of the deployment report template?
The report template generates a deployment summary including:
- timestamp
- infrastructure inventory counts
- host IPs and OS info
- deployed app and database name
- next steps for monitoring and verification
This is useful for documentation and operational handoff.

---

## 14) What common errors happen in multi-tier Ansible deployments?
Typical issues include:
- wrong inventory grouping or incorrect host variables
- firewall blocks (HTTP/MySQL ports not open)
- service not started/enabled
- missing dependencies (e.g., PyMySQL for MySQL modules)
- templating variable mismatch (undefined variables)

---

## 15) What real-world scenario does this lab simulate?
This lab simulates an enterprise deployment where automation must:
- configure multiple server roles (web + db)
- enforce consistent configuration
- deploy application artifacts
- run validation checks and reporting
This reflects real DevOps/IaC workflows for multi-server environments.
