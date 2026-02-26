# 🧪 Lab 03: Managing Inventory (Ansible)

## 🧾 Lab Summary
This lab focused on **Ansible inventory management**—building static inventories (INI + YAML), organizing hosts into groups, assigning group variables, validating inventory parsing, and confirming host connectivity. It also introduced **dynamic inventory** using Python scripts that return valid JSON output, and tested those scripts using both `ansible` and `ansible-inventory`. Finally, it demonstrated troubleshooting techniques including verbose SSH output, fact gathering per host, and performance checks for inventory parsing.

---

## 🎯 Objectives
By the end of this lab, I was able to:

- Create and configure static inventory files for Ansible automation
- Understand the structure and syntax of Ansible inventory files
- Implement dynamic inventory for cloud-based systems using scripts
- Test and validate inventory configurations using Ansible commands
- Troubleshoot common inventory-related issues
- Organize hosts into groups for efficient management
- Apply inventory variables to customize host configurations

---

## 📌 Prerequisites
Before starting this lab, the following knowledge was required:

- Basic Linux command line operations
- Familiarity with text editors (nano, vim, or gedit)
- Completion of Lab 01 and Lab 02 (Ansible basics + playbooks)
- Basic knowledge of YAML syntax
- Understanding of SSH key-based authentication
- Access to multiple Linux systems for testing

---

## 🖥️ Lab Environment
- **Environment Type:** Cloud lab environment (pre-configured nodes)
- **Control Node:** `ansible-control`
- **Managed Nodes:** `web1`, `web2`, `db1`
- **SSH:** Keys configured between nodes (first-time trust prompt may appear)
- **Working Directory:** `/home/student/ansible-labs/lab3-inventory`

> ✅ Note: This lab included both static and dynamic inventory practices.  
> Dynamic inventories were simulated using Python scripts that output JSON in Ansible’s expected format.

---

## 🗂️ Repository Structure
```text
lab03-managing-inventory/
├── README.md
├── commands.sh
├── output.txt
├── interview_qna.md
├── troubleshooting.md
└── inventory/
    ├── inventory.ini
    ├── advanced-inventory.ini
    ├── inventory.yml
    ├── dynamic-inventory.py
    ├── cloud-inventory.py
    └── test-inventory.yml
````

---

## ✅ Tasks Overview (What I Did)

### ✅ Task 1: Create Static Inventory Files

* Connected to the Ansible control node via SSH
* Created a dedicated lab directory: `lab3-inventory`
* Built **INI inventory** files:

  * Basic inventory with `webservers` and `databases`
  * `production:children` group combining both
  * Group variables using `[group:vars]`
* Built an **advanced inventory**:

  * added roles (`server_role`)
  * added additional groups (load balancers, staging)
  * used regional groups (`east-coast`, `west-coast`)
  * added global vars under `[all:vars]` for SSH and host key handling

### ✅ Task 2: Create YAML Inventory

* Created a static inventory in YAML format (`inventory.yml`)
* Organized hosts under `all:children`
* Added host variables and group vars with proper YAML indentation

### ✅ Task 3: Implement Dynamic Inventory (Python)

* Created a basic dynamic inventory script (`dynamic-inventory.py`)

  * supports `--list` and `--host <name>`
  * returns JSON with group structure and `_meta.hostvars`
* Created an advanced “cloud-like” dynamic inventory script (`cloud-inventory.py`)

  * simulates cloud discovery and tags
  * reads environment variables (`CLOUD_PROVIDER`, `CLOUD_REGION`, `ENVIRONMENT`)
  * generates environment-based grouping like `production_servers` or `staging_servers`

### ✅ Task 4: Test & Validate Inventories

* Tested connectivity using:

  * `ansible all -i inventory.ini -m ping`
  * group-specific targeting (`webservers`, `databases`)
* Tested YAML inventory parsing and connectivity
* Tested dynamic inventory usage directly as an inventory source:

  * `ansible all -i ./dynamic-inventory.py -m ping`
* Used `ansible-inventory` to inspect variables:

  * `--list`, `--host`, `--yaml`

### ✅ Task 5: Validate Inventory End-to-End with a Playbook

* Created a validation playbook (`test-inventory.yml`) to:

  * print host info (hostname, IP, user, groups)
  * run ping module
  * display system facts (OS, architecture)
  * display variable sets (`hostvars`) conditionally
* Executed the validation playbook with:

  * INI inventory
  * YAML inventory
  * dynamic inventory script

### ✅ Task 6: Performance & Troubleshooting Tools

* Benchmarked inventory parsing:

  * `time ansible-inventory -i inventory.ini --list`
  * `time ansible-inventory -i ./dynamic-inventory.py --list`
* Used `-vvv` to debug SSH connections and confirm inventory parsing plugin behavior
* Demonstrated SSH key generation and key deployment workflow (`ssh-keygen`, `ssh-copy-id`)

---

## ✅ Verification & Validation

The following checks confirmed successful lab completion:

* ✅ SSH access to control node verified
* ✅ Inventory file contents verified with `cat`, `head`, `sed`
* ✅ INI inventory parsed correctly using `ansible-inventory --list`
* ✅ YAML inventory worked with `ansible -i inventory.yml -m ping`
* ✅ Dynamic scripts returned valid JSON and supported `--list` and `--host`
* ✅ `ansible all -i ./dynamic-inventory.py -m ping` succeeded
* ✅ Validation playbook executed successfully across INI, YAML, and dynamic inventories
* ✅ Facts collected and stored using `setup --tree /tmp/facts`
* ✅ Inventory troubleshooting improved using `--yaml`, `-vvv`, and timing benchmarks

---

## 🧠 What I Learned

* How inventory acts as the “source of truth” for Ansible targeting and connectivity
* How to organize systems into groups (`webservers`, `databases`, `production`, etc.)
* How group vars (`[group:vars]`) simplify environment configuration across many hosts
* How YAML inventories map cleanly into Ansible’s internal structure (`all → children → hosts`)
* How dynamic inventories work (JSON + `_meta.hostvars`)
* How to simulate cloud discovery using scripts and environment variables
* How to validate and troubleshoot inventories using:

  * `ansible-inventory`
  * `ansible -m ping`
  * verbose SSH output (`-vvv`)
  * fact gathering per host (`setup --tree`)
  * performance timing (`time`)

---

## 🌍 Why This Matters

Inventory management is the foundation of effective automation. In stable environments, static inventories are clean and version-controlled. In cloud-based environments where systems change frequently, dynamic inventories become essential for scalable, automated infrastructure management.

---

## 🧩 Real-World Applications

* Managing multi-tier architectures (web/app/db/load balancer) using inventory groups
* Applying environment-specific vars (production vs staging) at inventory level
* Automating cloud infrastructure that scales up/down automatically
* Integrating dynamic inventory with cloud provider APIs (AWS/GCP/Azure) in real deployments
* Debugging SSH and connectivity issues quickly across a fleet

---

## ✅ Result

* Static inventories created (INI + advanced INI)
* YAML inventory created and validated
* Dynamic inventory scripts created and tested
* Inventory parsing, variables, groups, and host targeting validated end-to-end

✅ **Lab completed successfully on a cloud lab environment.**
