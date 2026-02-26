# 🎤 Lab 09: Using Roles in Playbooks — Interview Q&A

## 1) What is an Ansible role?
An Ansible role is a standardized way to organize automation content (tasks, handlers, templates, variables, and metadata) into a reusable structure. Roles make playbooks cleaner and allow consistent deployment patterns across environments.

---

## 2) Why are roles preferred over writing everything inside one playbook?
Roles improve:
- **Reusability** (use the same role in multiple playbooks)
- **Maintainability** (structured files instead of a huge YAML)
- **Collaboration** (teams can work on roles independently)
- **Scalability** (easy to extend for more servers and more configs)

---

## 3) What are the key folders inside a role and what do they do?
- `tasks/` → main actions executed by the role
- `handlers/` → service actions triggered by `notify`
- `templates/` → Jinja2 templates rendered with variables
- `files/` → static files copied as-is
- `defaults/` → lowest-precedence role variables
- `vars/` → higher-precedence role variables
- `meta/` → role metadata (platforms, dependencies, tags)

---

## 4) What is the difference between `defaults/main.yml` and `vars/main.yml`?
- `defaults/main.yml` variables are **low precedence** and easy to override.
- `vars/main.yml` variables are **higher precedence** and override defaults unless explicitly overridden at an even higher level (play vars, extra vars).
In this lab, defaults handled common values, while vars enforced role-specific overrides like port/timeouts/security flags.

---

## 5) How did templates help in this lab?
Templates allowed generating dynamic files based on host facts and variables:
- `index.html.j2` shows hostname, IP, OS, admin contact
- `vhost.conf.j2` builds a virtual host config with security/performance settings
This avoids hardcoding and supports multi-host deployments.

---

## 6) What are handlers and why are they useful?
Handlers run only when notified (usually after a change).  
They prevent unnecessary restarts and make automation efficient. In this lab, template changes notified a handler to restart Apache.

---

## 7) Why did the firewall task show errors but the playbook still succeeded?
The firewall task used:
- `ignore_errors: yes`
So even if Firewalld wasn’t running or DBus was unavailable, the playbook didn’t fail. This keeps the deployment resilient in environments where firewall management might not be active.

---

## 8) What does “role not found” mean and how do you fix it?
It usually means:
- the role directory name doesn’t match the role name in the playbook
- the `roles/` folder isn’t in the expected location
Fix by verifying:
- `roles/apache-webserver/` exists
- playbook references `apache-webserver` exactly

---

## 9) How did you include the role in a playbook?
In the `roles:` section:
```yaml
roles:
  - apache-webserver
````

This runs the role tasks against the target hosts.

---

## 10) How did you override role variables in the advanced playbook?

Two ways were used:

1. Play-level vars:

```yaml
vars:
  site_name: "production-site"
```

2. Role-level vars override:

```yaml
roles:
  - role: apache-webserver
    vars:
      max_connections: 200
      timeout: 600
```

---

## 11) How did you validate Apache was working after deployment?

Validation included:

* `curl http://<node-ip>` to confirm HTML page served
* `ansible ... -m service` to confirm `httpd` is started/enabled
* `httpd -t` to confirm Apache config syntax is OK

---

## 12) What is the purpose of creating a “common” role?

A common role provides baseline system setup shared across multiple roles/services, such as:

* system updates
* installing common tools (curl, vim, htop)
* setting timezone
  This reduces duplication across different service roles.

---

## 13) What did the `validate-deployment.yml` playbook test?

It validated:

* Apache is running (`service_facts` + `assert`)
* HTTP returns status `200` (`uri`)
* custom `index.html` exists (`stat` + `assert`)
  This makes the deployment testable and repeatable.

---

## 14) What is the purpose of `meta/main.yml` in a role?

It documents role information such as:

* supported platforms (EL7/8/9, Ubuntu versions)
* Ansible version requirement
* tags for discovery
* dependencies on other roles
  This is useful for sharing roles and maintaining documentation.

---

## 15) What real-world scenario does this lab map to?

This lab mirrors a real DevOps workflow where:

* teams create reusable service roles (web server role)
* deployments are standardized
* environment differences are handled through variable overrides
* validation is automated to reduce manual testing

