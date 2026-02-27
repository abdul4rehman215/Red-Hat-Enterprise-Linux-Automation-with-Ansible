# 🛠️ Troubleshooting Guide — Lab 20: Optimizing Playbooks and Performance (Ansible)

> This guide lists common issues seen when optimizing Ansible for scale and how to resolve them.

---

## 1) ❌ Roles Not Found / Role Path Issues

### ✅ Symptoms
- Error like:
  - `ERROR! the role 'webserver' was not found`
- Playbook can’t locate role directories

### 🔍 Likely Causes
- Wrong directory structure (roles not under `./roles`)
- Running playbook from a different working directory
- Custom roles_path not configured

### ✅ Fix
1. Confirm role folder exists:
```bash id="f7f0ex"
ls -la roles/
````

2. Run playbook from the lab root directory:

```bash id="02m5wp"
cd /home/ansible/lab20
ansible-playbook optimized-playbook.yml -i inventory
```

3. If needed, set roles_path in `ansible.cfg`:

```ini id="xsrfjm"
[defaults]
roles_path = ./roles
```

---

## 2) ❌ Roles Execute in Wrong Order / Dependencies Not Honored

### ✅ Symptoms

* Application role runs before webserver/database tasks
* App config fails because dependencies not ready

### 🔍 Likely Causes

* No dependencies defined
* Roles list order changed
* Dependency relationships not encoded

### ✅ Fix

Define dependencies in `roles/application/meta/main.yml`:

```yaml id="7gi0n1"
dependencies:
  - role: webserver
  - role: database
```

---

## 3) ❌ Handler Not Triggering / Webserver Not Restarting

### ✅ Symptoms

* Config file changes but service doesn’t restart
* No “RUNNING HANDLER” output

### 🔍 Likely Causes

* `notify:` missing in task
* Handler name mismatch (case-sensitive)
* Handler file not created / wrong role handler path

### ✅ Fix

1. Ensure task notifies handler:

```yaml id="zht5o2"
notify: restart webserver
```

2. Ensure handler exists in:
   `roles/webserver/handlers/main.yml`

```yaml id="f6cayr"
- name: restart webserver
  service:
    name: "{{ webserver_service }}"
    state: restarted
```

---

## 4) ❌ Async Tasks Never “Finish”

### ✅ Symptoms

* Playbook appears stuck waiting for async completion
* `async_status` never returns `finished: true`

### 🔍 Likely Causes

* Task truly still running (slow updates)
* Async timeout too low
* Not enough retries/delay
* Job ID undefined (async task failed before returning jid)

### ✅ Fix

1. Increase async window:

```yaml id="o5wm76"
async: 600
poll: 0
```

2. Increase polling retries:

```yaml id="7ob2z1"
retries: 60
delay: 10
```

3. Verify jid is defined before polling:

```yaml id="fyre1t"
when: package_update_job.ansible_job_id is defined
```

4. Manually check status:

```bash id="3w5v1t"
ansible all -m async_status -a "jid=<job_id>"
```

---

## 5) ❌ Delegation Tasks Fail on Control Node (openssl/nslookup missing)

### ✅ Symptoms

* Delegated task fails with “command not found”
* Example: `openssl: command not found`

### 🔍 Likely Causes

* Control node missing required utilities (openssl, bind-utils)

### ✅ Fix

Install required tools on control node:

```bash id="u69qji"
sudo yum install -y openssl bind-utils
```

---

## 6) ❌ Delegated “Copy from control node” Fails

### ✅ Symptoms

* `copy:` task fails because `/tmp/<host>.crt` not found

### 🔍 Likely Causes

* Cert generation ran with `run_once: true` but file naming is host-specific
* Only one cert created (for first host), but you attempt to copy per-host file

### ✅ Fix Options

**Option A (simple lab-friendly):** remove host-specific naming, generate one cert:

```yaml id="kxsl94"
-keyout /tmp/server.key
-out /tmp/server.crt
```

and copy `/tmp/server.crt` to all hosts.

**Option B (per-host):** remove `run_once` so each host’s cert is generated:

```yaml id="v4f3ym"
run_once: false
```

---

## 7) ❌ Performance Degrades When Forks Increased

### ✅ Symptoms

* Higher forks does not reduce runtime
* SSH failures/timeouts, or control node load spikes

### 🔍 Likely Causes

* Control node CPU/RAM saturated
* Network bottleneck
* Targets overwhelmed by parallel SSH
* Too many simultaneous package operations

### ✅ Fix

* Choose forks based on capacity (start conservative):

  * `forks = 5` → `10` → `20`
* Monitor control node CPU/memory during runs
* Consider batching with `serial:`:

```yaml id="bh3c2o"
serial: 10
```

---

## 8) ❌ Fact Gathering Takes Too Long (Large Inventories)

### ✅ Symptoms

* Long delay before tasks start
* `Gathering Facts` dominates runtime

### 🔍 Likely Causes

* Large inventory
* Slow hosts / network
* Redundant fact collection every run

### ✅ Fix

1. Enable fact caching (as done in lab):

```ini id="0o4pbi"
[defaults]
gathering = smart
fact_caching = jsonfile
fact_caching_connection = /tmp/ansible_facts_cache
fact_caching_timeout = 3600
```

2. Disable facts where not needed:

```yaml id="52zuo3"
gather_facts: no
```

---

## 9) ❌ `uri` Validation Fails in Post Tasks

### ✅ Symptoms

* Post task:

  * `Verify web service is accessible` fails
* HTTP 403/404 or connection refused

### 🔍 Likely Causes

* Web service not started or firewall blocked
* Wrong hostname resolution for `ansible_fqdn`
* Apache config invalid

### ✅ Fix

1. Verify service:

```bash id="9e5bwo"
ansible webservers -i inventory -m shell -a "systemctl status httpd && ss -tulpen | grep :80" --become
```

2. Validate Apache config:

```bash id="1x6f1c"
ansible webservers -i inventory -m shell -a "httpd -t" --become
```

3. Try IP-based URL:

```yaml id="p4w43q"
url: "http://{{ ansible_host | default(inventory_hostname) }}"
```

---

## 10) ✅ Recommended Performance Checklist

### Before running large deployments

* Use roles + tags
* Set forks appropriate for controller capacity
* Enable fact caching
* Enable pipelining (if safe)
* Avoid repeated downloads/build steps (delegate_to + run_once)
* Use async for slow tasks (updates, large operations)
* Measure improvements (benchmarks, reports)

---

## 11) Benchmark Results Interpretation (From Lab Run)

From `benchmark-playbooks.sh` output:

* Monolithic avg: **~8s**
* Role-based avg: **~5s**
* Async avg: **~4s**

This demonstrates improved performance by reducing wait time and increasing modular efficiency.
