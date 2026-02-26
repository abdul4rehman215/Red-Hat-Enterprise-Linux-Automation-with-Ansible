# 🎤 interview Q&A — Lab 15: Configuring Web Servers with Ansible (Apache)

## 1) Why use Ansible for web server configuration?
Ansible provides **repeatable automation** for installing and configuring services consistently across many servers. Instead of manual configuration (which leads to drift and errors), playbooks act as **infrastructure as code** and are easy to audit and reuse.

---

## 2) What is the purpose of an Ansible inventory file?
The inventory defines:
- managed hosts (IP/hostname)
- groups (e.g., `webservers`)
- variables like SSH user, private key, and SSH arguments  
This allows playbooks to target the right machines reliably.

---

## 3) Why did you create a directory structure (playbooks/templates/files/inventory)?
It improves maintainability and clarity:
- `playbooks/` keeps automation logic organized
- `templates/` holds dynamic Jinja2 content
- `files/` holds static assets (CSS)
- `inventory/` keeps host definitions separate  
This is a common best practice in real DevOps projects.

---

## 4) What are Ansible handlers and why use them?
Handlers run **only when notified**, which supports idempotency and efficiency.  
Example: restarting Apache only when its configuration changes, instead of restarting on every run.

---

## 5) Why did you use Jinja2 templates for the HTML page?
Templates allow dynamic content based on host facts like:
- hostname
- IP address
- OS version
- deployment time  
This makes each server page unique while keeping deployment automated.

---

## 6) What does idempotency mean in Ansible?
Idempotency means you can run the playbook multiple times and the system remains correct without unnecessary changes.  
In this lab, the second run showed `changed=0` for many tasks, proving safe re-runs.

---

## 7) Why did you open HTTP in the firewall using the `firewalld` module?
Even if Apache is running, users can’t access it if port 80 is blocked. The `firewalld` module ensures the required service (`http`) is allowed consistently and persistently.

---

## 8) Why use `wait_for` to check port 80?
It confirms that Apache is not only installed and “active”, but also **actually listening** on port 80. This is stronger validation than only checking service state.

---

## 9) What’s the difference between `copy` and `template` modules?
- `copy` copies static content exactly as-is (e.g., `style.css`)
- `template` renders Jinja2 variables into the output (e.g., `index.html.j2`)  
Templates are used when content needs to vary per host.

---

## 10) Why did you create `deploy-website.yml` separately from `install-apache.yml`?
Separating concerns improves reuse:
- One playbook handles installation/configuration
- Another handles application/content deployment  
This pattern mirrors real environments where content changes more frequently than base server configuration.

---

## 11) What is the benefit of tags like `install`, `configure`, and `verify`?
Tags allow selective execution. For example:
- run only installation tasks
- skip updates for speed
- run only verification checks  
Tags improve speed, control, and troubleshooting workflows.

---

## 12) Why did you use the `uri` module for verification?
It performs an HTTP request and validates response status codes. This is a programmatic way to confirm web server functionality and is ideal for automation pipelines.

---

## 13) What did the master playbook demonstrate?
It demonstrated a complete, repeatable workflow:
- install dependencies
- configure Apache
- configure firewall
- deploy content
- verify results
- print a summary  
This is a realistic “one-command deployment” approach.

---

## 14) What troubleshooting steps help if Apache doesn’t start?
Useful checks include:
- `httpd -t` for syntax validation
- `tail -20 /var/log/httpd/error_log` to inspect errors
- checking systemd status via Ansible  
These help quickly pinpoint config or runtime issues.

---

## 15) How is this lab relevant to DevOps / SysAdmin work?
It demonstrates core operational practices:
- infrastructure as code
- reproducible deployment
- service management
- firewall configuration
- automated testing/verification
These skills translate directly to real-world web infrastructure management and CI/CD automation.
