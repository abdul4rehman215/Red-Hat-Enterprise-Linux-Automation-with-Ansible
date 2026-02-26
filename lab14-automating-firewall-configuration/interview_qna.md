# 🎤 interview Q&A — Lab 14: Automating Firewall Configuration (Ansible + firewalld)

## 1) Why automate firewall configuration with Ansible?
Automation ensures **consistency**, **repeatability**, and **scale**. Instead of manually configuring rules on each server, playbooks apply the same baseline across multiple hosts, reducing errors and improving security posture.

---

## 2) What is the difference between a firewalld *service* and a *port rule*?
- **Service**: A named profile (e.g., `ssh`, `http`, `https`) that maps to predefined ports/protocols.
- **Port rule**: A direct rule opening a specific port/protocol (e.g., `8080/tcp`, `60000-61000/tcp`).  
Services are easier to manage and more readable; port rules are more explicit and flexible.

---

## 3) Why use both `permanent: yes` and `immediate: yes`?
- `permanent: yes` saves changes to persistent configuration (survive reboot)
- `immediate: yes` applies changes to runtime immediately (no reload required)

Using both ensures the firewall is correct **now** and also after reboot.

---

## 4) What is a firewalld zone?
A **zone** represents a trust level for a network interface or source. Each zone contains its own allowed services/ports/rich rules. Example:
- `public` → more restrictive, internet-facing
- `trusted` → more permissive, internal networks
- custom zones like `dmz-custom` → tailored rules for DMZ servers

---

## 5) What are *rich rules* and why are they useful?
Rich rules provide **granular firewall control** beyond basic service/port rules, such as:
- allowing traffic only from specific source subnets
- rate limiting (e.g., SSH brute-force mitigation)
- logging dropped packets
- dropping specific IPs

---

## 6) Why did you explicitly disable Telnet (23/tcp)?
Telnet transmits credentials in plaintext and is considered insecure. Ensuring it is disabled is a common hardening baseline (least privilege and secure defaults).

---

## 7) How did you validate the firewall behavior after changes?
Using the testing playbook with `wait_for`:
- SSH (22) should be reachable (required for management)
- HTTP (80) should be reachable only where expected (web server role)
- Telnet (23) should fail (blocked)

This provides an automated PASS/BLOCKED report per host.

---

## 8) Why did HTTP succeed on node1 but fail on node2 in testing?
Because node1 was treated as a **web server** role, where HTTP is expected open.  
Node2 was treated as a **database server** role, where HTTP isn’t required, so it remained blocked by default policy.

---

## 9) What is the purpose of creating a custom service definition XML?
Custom services allow you to define an application once (ports + description), then enable it by name (e.g., `custom-app`) rather than managing raw ports everywhere. This improves readability and standardization.

---

## 10) Why do you need `firewall-cmd --reload` after creating a custom XML service?
Firewalld reads service definitions from `/etc/firewalld/services/`. After adding a new XML file, a reload is required so firewalld recognizes the new service name.

---

## 11) Why did you create a custom zone like `dmz-custom`?
To model a real-world segmentation scenario where DMZ servers require only a limited set of services (typically web + management). This supports security zoning and controlled exposure.

---

## 12) What does it mean when an interface is assigned to a zone?
Traffic on that interface is filtered according to that zone’s rules.  
Example: `eth0` in `public` means incoming connections follow the public policy.

---

## 13) How do you troubleshoot “rules not persisting” across reboot?
Make sure rules were configured using:
- `permanent: yes`
And verify persistent configuration using:
- `firewall-cmd --list-all --permanent` (commonly used in real checks)
Then reload and re-check:
- `firewall-cmd --reload`

---

## 14) What are common causes of firewalld not working properly?
- service not running (`systemctl status firewalld`)
- conflicting firewall stack (`iptables` service active on some systems)
- rules added only runtime but not permanent
- incorrect zone assignment

---

## 15) How is this lab relevant to real-world security engineering / DevSecOps?
It demonstrates:
- enforcing baseline security policy across fleets
- least privilege rule design
- segmentation between tiers (web vs db)
- audit artifacts (backup configs)
- automated testing to prevent accidental lockouts or exposures

This is directly applicable to enterprise hardening, cloud security baselines, and compliance-driven firewall management.
