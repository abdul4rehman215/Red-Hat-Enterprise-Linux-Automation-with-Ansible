# 🎤 interview_qna.md — Lab 17: Orchestrating Multiple Tasks (Ansible)

## 1) What does “orchestrating multiple tasks” mean in Ansible?
**Answer:**  
It means coordinating multiple systems and components (DB, web servers, load balancer, monitoring) in the **correct order**, with dependencies and validations, so the whole stack deploys reliably as one workflow.

---

## 2) Why did we use a “master” playbook (`site.yml`)?
**Answer:**  
A master playbook provides a **single entry point** for deployment. It controls **execution order**, groups phases logically, and lets us run the entire stack or only specific phases using tags.

---

## 3) What is the difference between `import_playbook` and `include_tasks`?
**Answer:**  
- `import_playbook` loads another playbook at **parse time** and is used for **multi-playbook orchestration**.  
- `include_tasks` loads tasks dynamically at **runtime** and is used inside a play for conditional or modular task loading.

---

## 4) Why was `gather_facts: true` used on `localhost` in `site.yml`?
**Answer:**  
Because `ansible_date_time` is a fact. Without gathering facts, `ansible_date_time` is undefined. Enabling `gather_facts: true` ensures we can generate a deployment timestamp and ID.

---

## 5) How did the lab enforce “database first” before deploying web servers?
**Answer:**  
The webserver playbook includes a `pre_tasks` check:
- It fails if `database_deployed` is not defined for the database host:
```yaml
when: hostvars[groups['database_servers'][0]]['database_deployed'] is not defined
````

This prevents web servers from deploying before the database is ready.

---

## 6) How did web servers learn the database host IP?

**Answer:**
The database playbook sets facts after successful deployment:

```yaml
set_fact:
  database_host: "{{ ansible_default_ipv4.address }}"
```

Then web servers reference it using:

```yaml
db_host: "{{ hostvars[groups['database_servers'][0]]['database_host'] }}"
```

---

## 7) What is the purpose of `pre_tasks` and `post_tasks`?

**Answer:**

* `pre_tasks` runs before main tasks and is used for **checks / prerequisites** (reachability, dependency validation).
* `post_tasks` runs after main tasks and is used for **verification / exporting facts** for downstream plays.

---

## 8) Why did we run `dependency_check.yml` before `site.yml`?

**Answer:**
It validates system readiness:

* Connectivity between nodes
* Minimum disk availability
* Basic port availability
  Running this before deployment reduces failure risk mid-deployment.

---

## 9) How was the load balancer configured to depend on web servers?

**Answer:**
Load balancer `pre_tasks` use `uri` checks to confirm web servers return HTTP 200:

```yaml
uri:
  url: "http://{{ item }}:80"
  status_code: 200
```

If any backend is down, the playbook fails early.

---

## 10) What is the advantage of using Jinja2 templates in this lab?

**Answer:**
Templates allow dynamic configuration generation:

* app config gets DB host and credentials dynamically
* HAProxy backend list is built from inventory groups
* Apache vhost config is created consistently across nodes
  This reduces duplication and supports scale.

---

## 11) Why were Ansible tags used, and how are they helpful?

**Answer:**
Tags allow **partial deployments** without running everything:

* `--tags database` runs only database deployment
* `--tags webservers` runs only web server deployment
* `--tags loadbalancer` runs only load balancer deployment
  This is useful for faster iteration and troubleshooting.

---

## 12) What does idempotency mean, and how did we observe it here?

**Answer:**
Idempotency means running playbooks multiple times results in **no unnecessary changes** after the system is already configured.
We saw this when re-running tagged phases showed `ok` instead of `changed`.

---

## 13) What is the purpose of the rollback playbook?

**Answer:**
Rollback provides a controlled way to:

* stop services (httpd, mariadb, haproxy)
* remove deployed app files/config
* remove firewall rules (best-effort)
  This helps recover quickly from failed deployments or bad changes.

---

## 14) What are common orchestration failure points in multi-tier deployments?

**Answer:**

* Dependency order problems (web servers before DB)
* Network/firewall misconfiguration
* Service start failures (httpd/mariadb/haproxy)
* Template errors causing invalid configs
* Wrong inventory/group variables

---

## 15) If the playbook fails, what debugging steps would you take?

**Answer:**

* Run with verbosity: `ansible-playbook ... -vvv`
* Test connectivity: `ansible all -m ping`
* Gather facts: `ansible all -m setup`
* Check services: `systemctl status httpd mariadb haproxy`
* Validate configs (example): `haproxy -c -f /etc/haproxy/haproxy.cfg`
* Inspect logs (Apache error logs, journalctl)
