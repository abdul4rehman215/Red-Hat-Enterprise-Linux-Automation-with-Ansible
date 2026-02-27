# 🧠 Interview Q&A — Lab 07: Handlers and Notifications

---

## 1) What is a handler in Ansible?
A handler is a special task that runs **only when notified** by another task. It is commonly used for actions like restarting or reloading services after configuration changes.

---

## 2) Why do we use handlers instead of restarting services directly in tasks?
Handlers prevent unnecessary restarts. A service restart can cause downtime or disruption, so handlers ensure restarts happen **only when something actually changed**.

---

## 3) What does `notify` do?
`notify` triggers (queues) a handler when a task results in `changed`. If the task is `ok`, the handler is not called.

Example:
```yaml
notify: restart nginx
````

---

## 4) When do handlers run by default?

Handlers run **at the end of the play** after all normal tasks finish.

---

## 5) Can multiple tasks notify the same handler?

Yes. Multiple tasks can notify the same handler, but the handler will execute **only once per play**, even if notified multiple times.

---

## 6) In this lab, why did the handler run on the first execution?

Because the `lineinfile` task changed `/etc/nginx/nginx.conf` by setting:

```text
worker_processes 4;
```

When Ansible detected the change, it notified the handler which restarted nginx.

---

## 7) Why didn’t the handler run on the second execution?

Because the file already had the correct configuration line, so the task returned `ok` instead of `changed`. Since there was no change, no notification happened.

---

## 8) What module was used to edit the nginx configuration file and why?

The `lineinfile` module was used to ensure a specific line exists or is modified safely and idempotently.

---

## 9) Which module was used in the handler, and what did it do?

The `service` module was used:

```yaml
service:
  name: nginx
  state: restarted
```

This restarted the nginx service only when triggered.

---

## 10) What does idempotency mean, and how did this lab demonstrate it?

Idempotency means you can run automation multiple times and the system stays consistent without repeated unnecessary changes.
This lab demonstrated it when the second run made no changes and did not restart nginx.

---

## 11) How can you force handlers to run immediately instead of waiting until the end?

You can use:

```yaml
- meta: flush_handlers
```

This forces queued handlers to execute immediately at that point in the play.

---

## 12) What are best practices for naming handlers?

* Use clear action-based names (`restart nginx`, `reload sshd`)
* Match the `notify` name exactly
* Keep naming consistent across playbooks/roles for readability

---

## 13) What are common issues when handlers don’t run?

* task didn’t change, so notify never triggered
* handler name mismatch (notify name != handler name)
* handler placed incorrectly in YAML (wrong indentation/position)
* handler suppressed because the play failed before completion (unless flushed)

---

## 14) How did you verify nginx restarted and is running correctly?

Using systemd:

```bash
systemctl status nginx --no-pager
```

It showed `Active: active (running)` confirming nginx is running properly.

---

## 15) Where are handlers most useful in real-world automation?

* Restarting web servers after config changes
* Reloading firewall rules after updates
* Restarting SSH after config edits
* Reloading systemd after unit file changes
* Restarting databases after parameter tuning

---
