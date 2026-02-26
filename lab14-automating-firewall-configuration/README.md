# 🔥 Lab 14: Automating Firewall Configuration (Ansible + firewalld)

## 🧾 Lab Summary
In this lab, I automated **firewall configuration** across multiple Linux systems using Ansible and the `firewalld` module. I validated the lab environment, ensured `firewalld` was installed and running, then applied:

- **Basic service rules** (SSH/HTTP/HTTPS)
- **Custom port rules** (8080, 3306, 5432, port ranges)
- **Rich rules** (source filtering, rate limiting, logging, drops)
- **Zone-based policies** (custom DMZ zone + trusted/internal sources)
- **Custom firewalld services** (XML service definition + reload)
- **Automated testing & backups** (connectivity checks + config backup files)

> Environment note: executed in a **guided cloud lab environment** with a CentOS/RHEL-based control node and two managed nodes.

---

## 🎯 Objectives
By the end of this lab, I was able to:

- Configure firewall rules using Ansible `firewalld` module
- Manage firewall **zones and services** using automation
- Create and apply firewall policies across multiple systems
- Understand how firewalld **zones, services, ports, and rich rules** work together
- Implement security best practices using automated firewall management
- Troubleshoot common firewall issues in automated deployments

---

## ✅ Prerequisites
- Basic Linux command-line knowledge
- Familiarity with Ansible fundamentals (inventory, playbooks, modules)
- Networking basics (ports, protocols, services)
- Firewall fundamentals (zones, rules, least privilege)
- Completion of earlier Ansible labs or equivalent experience

---

## 🧰 Lab Environment
**Control Node**
- CentOS/RHEL 8 (Ansible pre-installed)

**Managed Nodes**
- Two target systems: `node1`, `node2`

**Access**
- All systems can communicate
- Sudo access available on all managed nodes

---

## 📁 Repository Structure (Lab Folder)

```text
lab14-automating-firewall-configuration/
├── README.md
├── commands.sh
├── output.txt
├── inventory
├── basic-firewall.yml
├── advanced-firewall.yml
├── rich-rules.yml
├── zones-management.yml
├── services-management.yml
├── security-policy.yml
├── firewall-testing.yml
└── troubleshoot-firewalld.yml
````

---

## 🧩 Tasks Overview

### ✅ Task 1: Configure Firewall Rules (firewalld module)

* Verified Ansible installation and connectivity
* Ensured `firewalld` is **installed, started, enabled**
* Applied a baseline firewall ruleset:

  * Allowed: `ssh`, `http`, `https`
* Confirmed applied rules with `firewall-cmd --list-all`

### ✅ Task 2: Advanced Ports + Rich Rules

* Opened custom ports used by common workloads:

  * `8080/tcp`, `3306/tcp`, `5432/tcp`
  * Port range: `60000-61000/tcp`
* Ensured insecure or unnecessary services were disabled (example: Telnet / 23)
* Added rich rules for:

  * Source-based allow/deny
  * Rate limiting SSH connections
  * Logging dropped packets

### ✅ Task 3: Zones + Services Management

* Listed zones and default zone configuration
* Created a custom zone `dmz-custom` and enabled specific services inside it
* Added trusted source network rules for internal communication
* Managed services:

  * Enabled common services in `public`
  * Created a custom service definition (`custom-app.xml`)
  * Reloaded firewalld to register new services
  * Verified enabled services

### ✅ Task 4: Role-Based Security Policy + Validation

* Implemented a policy approach based on server role:

  * `node1` treated as **web server** (public-facing)
  * `node2` treated as **db server** (restricted access)
* Applied common hardening rules across all nodes:

  * Disabled common attack ports
  * Enabled logging for drop events
* Validated configuration with automated testing playbook:

  * SSH allowed
  * HTTP allowed only where expected
  * Telnet blocked
* Backed up final firewall configs to `/tmp/firewall-backup-<host>.txt`

---

## ✅ Verification & Validation

Validation was performed using:

* `firewall-cmd --state`
* `firewall-cmd --list-all`
* `firewall-cmd --list-rich-rules`
* Zone queries (`--get-zones`, `--get-default-zone`, `--get-zone-of-interface`)
* Automated tests (`wait_for` checks on ports 22, 80, 23)
* Backup files created under `/tmp/firewall-backup-*.txt`

---

## 🧾 Result

* ✅ firewalld installed + running + enabled on both nodes
* ✅ Baseline services opened (SSH/HTTP/HTTPS)
* ✅ Custom ports opened and confirmed
* ✅ Rich rules applied (source filters, rate limits, drop logging)
* ✅ Zones managed (custom DMZ + trusted source rules)
* ✅ Custom service created and enabled
* ✅ Validation reports + backups generated

---

## 🛡️ Why This Matters

Automating firewall configuration helps:

* Reduce human error in security controls
* Ensure consistent firewall posture across many systems
* Enable scalable policy deployment (10 → 1000 nodes)
* Provide auditable infrastructure-as-code documentation
* Support DevOps security workflows and compliance requirements

---

## 🧠 What I Learned

* How Ansible `firewalld` module manages services, ports, and rich rules
* How zones represent different trust levels and enforce policy boundaries
* How to create a custom service definition using XML and reload firewalld
* How to implement role-based access and least privilege firewall design
* How to validate firewall state automatically and generate backups for auditing

---

## 🌍 Real-World Applications

* Enforcing baseline firewall policy across fleets of servers
* Cloud security hardening and compliance enforcement
* Segmentation between web and database tiers
* Automated response workflows (blocking, logging, limiting)
* Operational security audits and configuration backups

---

## ✅ Conclusion

This lab demonstrated how to implement **enterprise-grade firewall configuration** using Ansible automation. I created reusable playbooks to manage firewalld rules, services, zones, and rich rules—then validated behavior through automated connectivity tests and backup artifacts. This approach scales well and aligns with security best practices such as least privilege and standardized policy enforcement.

✅ Lab completed successfully in a guided cloud lab environment
✅ Firewall rules + zones + services + validation playbooks generated
