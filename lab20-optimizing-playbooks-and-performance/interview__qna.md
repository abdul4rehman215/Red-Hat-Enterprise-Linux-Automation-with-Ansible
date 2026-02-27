# 🎤 Interview Q&A — Lab 20: Optimizing Playbooks and Performance (Ansible)

## 1) Why are monolithic playbooks considered a maintenance and performance problem?
**Answer:**  
They mix multiple responsibilities into one file, which makes them hard to read, hard to reuse, and difficult to troubleshoot. At scale, they encourage repeated logic and reduce modular execution (e.g., you can’t easily re-run only one component cleanly).

---

## 2) How do Ansible roles improve playbook optimization?
**Answer:**  
Roles improve:
- **Maintainability:** clear separation (webserver/database/app/security/monitoring)
- **Reusability:** roles can be reused across multiple playbooks/projects
- **Collaboration:** teams can work on roles independently
- **Execution control:** roles can be tagged and selectively executed

---

## 3) What is the advantage of using role defaults (`defaults/main.yml`)?
**Answer:**  
Defaults provide safe baseline variables that can be overridden from inventory/group_vars/extra vars. This makes roles portable and reusable.

---

## 4) What is the purpose of handlers in optimized playbooks?
**Answer:**  
Handlers prevent unnecessary restarts by only running when notified. This reduces disruption and speeds execution (no repeated service restarts after every config task).

---

## 5) What does `async` do in Ansible?
**Answer:**  
`async` lets a long-running task start and run in the background. It improves overall playbook performance by not blocking the entire run while waiting for that one task.

---

## 6) What does `poll: 0` mean with async jobs?
**Answer:**  
It means “fire-and-forget.” Ansible starts the job and immediately continues to the next tasks without waiting for completion.

---

## 7) How do you check completion of an async task?
**Answer:**  
Use `async_status` with the job ID:
```yaml id="v7x5eq"
- async_status:
    jid: "{{ package_update_job.ansible_job_id }}"
  register: package_result
  until: package_result.finished
  retries: 30
  delay: 10
````

---

## 8) What is task delegation and why can it improve performance?

**Answer:**
Delegation runs a task on a different host than the current target. Commonly, `delegate_to: localhost` runs tasks on the control node to avoid repeated work on every managed node (e.g., generating certs, doing DNS lookups, downloading large files once).

---

## 9) Why is `run_once: true` useful with delegation?

**Answer:**
It ensures a delegated task runs only one time even when targeting multiple hosts. This is perfect for tasks like downloading artifacts or generating shared resources.

---

## 10) What does `strategy: free` change in Ansible execution?

**Answer:**
It allows hosts to run independently without waiting for other hosts to finish each task step. This can speed up playbooks when some hosts are slower than others.

---

## 11) What is the purpose of tuning `forks` in `ansible.cfg`?

**Answer:**
`forks` controls how many hosts Ansible can manage in parallel. Increasing forks can reduce runtime in large inventories, but too many forks can overload the control node or the network.

---

## 12) Why can increasing forks sometimes make performance worse?

**Answer:**
Because:

* control node CPU/RAM becomes saturated
* network becomes congested
* target nodes may be resource-limited
* SSH connection setup overhead increases

So the “best” forks value depends on environment capacity.

---

## 13) What is fact caching and why does it matter?

**Answer:**
Fact caching stores gathered facts so repeat runs don’t have to re-collect everything. In large environments, this reduces overhead and speeds up playbooks significantly.

---

## 14) How did we measure performance improvements in this lab?

**Answer:**
We used:

* a benchmarking script `benchmark-playbooks.sh` running multiple iterations and computing averages
* performance analysis playbook (`analyze-performance.yml`) to summarize results and generate dashboard JSON
* HTML report templates to compare execution times and status

---

## 15) What were the measured benchmark results in this lab run?

**Answer:**
From the benchmarking output:

* **Monolithic playbook:** average ~8s
* **Role-based optimized playbook:** average ~5s
* **Async playbook:** average ~4s

This shows modular roles and async execution reduced total runtime.

---

## 16) What is a common async troubleshooting issue and how do you address it?

**Answer:**
Async tasks may appear stuck if:

* timeout too low
* job is still running but never polled
  Fix by:
* increasing `async` timeout
* using `async_status` with retries/delay
* optionally using `poll: 10` if you want periodic waiting.

---

## 17) Why is modularity also a security and reliability improvement?

**Answer:**
It reduces blast radius:

* failures are isolated to a role
* security tasks can be tagged and enforced consistently
* auditing is easier because concerns are separated (security vs app vs database).
