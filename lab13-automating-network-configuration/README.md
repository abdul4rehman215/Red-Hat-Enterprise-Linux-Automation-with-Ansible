# 🌐 Lab 13: Automating Network Configuration (Ansible)

## 🧾 Lab Summary
This lab focuses on **automating Linux network configuration** using Ansible playbooks and the `community.general.nmcli` module.  
I used an Ansible control node to configure **static IPs**, create **additional NetworkManager profiles**, apply **static routes**, automate **DNS configuration**, and generate **validation reports** fetched back to the control node.

> Environment note: this was performed in a **guided cloud lab environment** with an Ansible control node and two managed nodes.

---

## 🎯 Objectives
By the end of this lab, I was able to:

- Configure network interfaces using Ansible’s `nmcli` module
- Automate **static IP** assignment and interface management
- Set up **routing configurations** using Ansible playbooks
- Configure **DNS settings** automatically using Ansible + templates
- Understand fundamentals of **network automation** in enterprise environments
- Troubleshoot common issues in automated network deployments

---

## ✅ Prerequisites
- Basic Linux networking knowledge (IP/subnet/routing/DNS)
- Ansible fundamentals (inventory, playbooks, modules)
- YAML syntax familiarity
- SSH connectivity (key-based authentication)
- Basic Linux CLI experience

---

## 🧰 Lab Environment
**Topology**
- Control node: `ansible-controller`
- Managed nodes: `node1`, `node2`

**Assumptions / Baseline**
- SSH access is available (keys configured; one-time password prompt may occur)
- NetworkManager is used on managed nodes
- Ansible is installed on the control node

---

## 📁 Repository Structure (Lab Folder)

```text
lab13-automating-network-configuration/
├── README.md
├── commands.sh
├── output.txt
├── inventory
├── configure-static-ip.yml
├── configure-secondary-interface.yml
├── configure-routing.yml
├── configure-dns.yml
├── master-network-config.yml
├── validate-network.yml
├── configure-vlan.yml
├── configure-bonding.yml
├── templates/
│   └── resolv.conf.j2
└── reports/
    ├── node1_network_report.txt
    └── node2_network_report.txt
````

---

## 🧩 Tasks Overview

### ✅ Task 1: Configure Network Interfaces (NetworkManager / nmcli)

* Verified initial IP configuration and NetworkManager profiles
* Created a dedicated lab directory and inventory
* Installed the required Ansible collection (`community.general`)
* Automated static IP assignment per node
* Created an additional NetworkManager profile (`secondary-net`) for demonstration

### ✅ Task 2: Configure Routing + DNS

* Added custom static routes via NetworkManager + route files for persistence
* Automated DNS servers + search domains
* Templated `/etc/resolv.conf` using `resolv.conf.j2`
* Updated `nsswitch.conf` to prioritize DNS resolution
* Validated gateway connectivity + DNS lookups

### ✅ Task 3: Validation + Reporting

* Built a validation playbook to:

  * Check device state
  * Confirm active connection
  * Test internet reachability
  * Generate a host report (IP, routes, DNS)
  * Fetch reports back to the control node (`./reports/`)

---

## ✅ Verification & Validation

I verified outcomes using:

* `ip addr show` to confirm static IP assignment
* `nmcli connection show` to confirm profiles exist and active connection is correct
* `ip route show` to validate static routes
* `nslookup google.com` to validate DNS resolution
* Automated generated reports (`reports/node1_network_report.txt`, `reports/node2_network_report.txt`)

---

## 🧾 Result

* ✅ Static IPs applied successfully:

  * node1 → `192.168.1.100/24`
  * node2 → `192.168.1.101/24`
* ✅ Custom routes added and verified in routing table
* ✅ DNS servers + search domains applied consistently
* ✅ Reports generated on nodes and fetched to control node
* ✅ Playbooks serve as **infrastructure-as-code documentation** for network config

---

## 🌍 Why This Matters

Network automation is essential because it:

* Reduces human configuration mistakes that can cause downtime
* Enforces consistent network baselines across environments
* Enables rapid, scalable provisioning (10 → 1000 nodes)
* Produces auditable, repeatable configuration as code

---

## 🧠 What I Learned

* How to automate NetworkManager profiles using Ansible `nmcli`
* Why YAML structure (tasks/handlers indentation) matters for correct execution
* How to apply and verify routes in an automated workflow
* How templating (`.j2`) ensures consistent DNS configuration across nodes
* How to generate “proof” artifacts (reports) and fetch them back centrally

---

## 🏢 Real-World Applications

* Data center server provisioning (consistent static IP and DNS)
* Cloud VM fleet management (automated network baselines)
* Disaster recovery (rapid restore of routes/DNS)
* Compliance enforcement (standardized network configuration)

---

## ✅ Conclusion

In this lab, I successfully automated network configuration using Ansible across multiple nodes—covering **static IPs, routing, DNS, and validation/reporting**. This workflow reflects real enterprise patterns where network configuration must be consistent, repeatable, and verifiable using infrastructure-as-code practices.

✅ Lab completed successfully on the guided cloud lab environment
✅ All playbooks + templates + reports generated
