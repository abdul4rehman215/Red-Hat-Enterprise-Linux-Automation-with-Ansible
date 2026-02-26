# 🚀 Lab 20: Optimizing Playbooks and Performance (Ansible)

## 📌 Lab Summary
This lab focused on improving Ansible execution performance and maintainability by applying real-world optimization techniques:

- Refactoring a **monolithic playbook** into a **role-based architecture**
- Using **asynchronous execution** (`async`, `poll`, `async_status`) to reduce wall-clock time
- Applying **delegation** (`delegate_to`, `run_once`) to offload expensive work to the control node
- Improving scalability via **parallel execution** (strategy `free`, higher forks)
- Measuring and comparing performance using a benchmarking framework and reports (HTML + JSON)

The end result was a set of modular playbooks and roles plus benchmarking artifacts to validate improvements in a repeatable way.

---

## 🎯 Objectives
By the end of this lab, I was able to:

- Understand playbook optimization principles and best practices for Ansible automation
- Split large playbooks into modular roles to improve maintainability and reusability
- Implement asynchronous execution and delegation to enhance task performance
- Test and measure playbook efficiency in simulated large-scale environments
- Apply performance tuning techniques to optimize Ansible playbook execution
- Troubleshoot common performance bottlenecks in Ansible automation

---

## ✅ Prerequisites
To complete this lab, the following background was required:

- Basic understanding of Ansible fundamentals (playbooks, tasks, modules)
- Familiarity with YAML syntax and Ansible playbook structure
- Knowledge of Linux command line operations
- Understanding of SSH connectivity and remote system management
- Completion of previous Ansible labs or equivalent experience
- Basic understanding of system administration concepts

---

## 🧰 Lab Environment
**Environment Type:** Cloud lab environment (RHEL/CentOS-based)  
**Control Node:** CentOS/RHEL 8 with Ansible pre-installed  
**Managed Nodes:** 3 target systems used to validate optimization techniques  
**Access:** SSH keys preconfigured for connectivity  
**Base Lab Directory:** `/home/ansible/lab20`

---

## ✅ What I Performed (Task Overview)

### ✅ Task 1: Split Large Playbooks into Roles for Modularity
- Reviewed `large-playbook.yml` (a monolithic “do everything” playbook).
- Identified distinct responsibilities:
  - web server setup
  - database setup
  - application deployment
  - monitoring tooling
  - security baseline
- Created role structure under `roles/`:
  - `webserver`, `database`, `application`, `monitoring`, `security`
- Extracted tasks into dedicated roles with:
  - `defaults/` for variables
  - `tasks/` for role logic
  - `handlers/` for restarts
  - `templates/` for configuration files
- Created `optimized-playbook.yml` that executes roles with tags and validates service access.
- Added a small `site.yml` wrapper playbook for orchestration + summary output.

### ✅ Task 2: Optimize With Async Execution and Delegation
- Built an async demo playbook using:
  - `async:`, `poll: 0`, and `async_status` to check completion
- Built a delegation demo playbook using:
  - `delegate_to: localhost` + `run_once: true` for expensive “control-node-only” tasks:
    - generate SSL certificates
    - optional large file download
    - DNS lookups and centralized status logging
    - connectivity checks from control node
- Implemented parallel-host execution using:
  - `strategy: free` for independent host progress

### ✅ Task 3: Benchmark and Measure Performance
- Built a performance testing framework that executes multiple playbooks using:
  - check mode + verbosity (simulated safely)
  - time measurement using `ansible_date_time.epoch`
- Generated HTML reports from templates:
  - performance report for playbooks
  - fork comparison report
- Created simulated “large environment” inventory and `ansible.cfg` tuned for performance:
  - increased `forks`
  - fact caching enabled
  - pipelining enabled
  - host key checking disabled for lab simulation
- Built monitoring workflow that captures system CPU/memory periodically into a log file.
- Created a benchmarking script `benchmark-playbooks.sh` to run multiple iterations and compute averages.
- Added an analysis playbook to summarize benchmark runs and output JSON dashboard data.

---

## 🧾 Repository Structure
```text
lab20-optimizing-playbooks-and-performance/
├── README.md
├── commands.sh
├── output.txt
├── interview_qna.md
├── troubleshooting.md
├── inventory
├── ansible.cfg
├── large-inventory
├── large-playbook.yml
├── optimized-playbook.yml
├── site.yml
├── async-optimization.yml
├── delegation-optimization.yml
├── parallel-optimization.yml
├── performance-test.yml
├── run-performance-test.yml
├── performance-report.j2
├── monitor-performance.yml
├── fork-performance-test.yml
├── fork-comparison-report.j2
├── benchmark-playbooks.sh
├── analyze-performance.yml
└── roles/
    ├── webserver/
    │   ├── defaults/main.yml
    │   ├── handlers/main.yml
    │   ├── tasks/main.yml
    │   └── templates/httpd.conf.j2
    ├── database/
    │   ├── defaults/main.yml
    │   ├── handlers/main.yml
    │   ├── tasks/main.yml
    │   └── templates/my.cnf.j2
    ├── application/
    │   ├── defaults/main.yml
    │   ├── meta/main.yml
    │   ├── tasks/main.yml
    │   └── templates/app-config.php.j2
    ├── monitoring/
    │   └── tasks/main.yml
    └── security/
        └── tasks/main.yml
````

---

## ✅ Verification & Testing Performed

* Confirmed roles directory structure created correctly (`tree roles/`).
* Converted monolithic playbook into role-based approach and validated execution order using tags.
* Verified the role-based deployment could be tested via `uri` in `post_tasks`.
* Validated async tasks complete by polling with `async_status`.
* Confirmed delegation tasks execute on control node via `delegate_to: localhost` and `run_once`.
* Tested parallel host execution using `strategy: free`.
* Benchmarked playbooks using:

  * `benchmark-playbooks.sh` (multiple iterations + averages)
  * performance test playbooks that generate HTML and JSON outputs
* Verified performance analysis summary generated successfully using `analyze-performance.yml`.

---

## 🧠 What I Learned

* Why monolithic playbooks become slow and hard to maintain at scale
* How roles improve:

  * reuse
  * separation of concerns
  * readability and maintainability
* How `async` reduces “waiting time” for long tasks and allows other tasks to proceed
* How delegation reduces repetitive work on each node and centralizes heavy tasks
* How tuning Ansible settings (`forks`, fact caching, pipelining) impacts performance
* How to build a measurable benchmarking workflow so optimization is data-driven

---

## 🌍 Why This Matters

In enterprise environments, Ansible runs against many hosts where performance issues become visible quickly:

* high SSH overhead
* expensive fact gathering
* long-running package updates
* unnecessary repetition of identical tasks
* poor modularity and hard-to-debug monolithic playbooks

This lab mirrors real infrastructure automation optimization work:

* refactor for maintainability
* reduce execution time
* scale across larger inventories
* validate improvements with measurable benchmarking

---

## 🧩 Real-World Applications

* Large fleet patching and compliance automation
* Role-based infrastructure provisioning
* Enterprise deployments with reusable shared roles
* Faster CI/CD automation and safer change previews
* Performance tuning for AWX/Tower or large-scale Ansible pipelines

---

## ✅ Result

* ✅ Monolithic playbook refactored into modular roles
* ✅ Async execution implemented and validated
* ✅ Delegation and parallel strategy applied
* ✅ Large inventory simulation created
* ✅ `ansible.cfg` tuned for speed and reduced overhead
* ✅ Benchmarks produced measurable improvements and generated reports
* ✅ Analysis playbook produced summary + dashboard JSON output

---

## 🏁 Conclusion

This lab demonstrated how to take an Ansible automation workflow from “works on a few hosts” to a more scalable, maintainable, and performance-aware approach. By combining **roles**, **async execution**, **delegation**, and **tuning**, playbooks become faster and easier to manage—especially in environments where Ansible targets large numbers of servers.
