# 🧪 Lab 05: Variables and Facts (Ansible)

## 🧾 Lab Summary
This lab focused on **variables and facts** in Ansible. I created multiple playbooks demonstrating different variable types, external variable files (`group_vars` and `host_vars`), Ansible fact gathering, and conditional task execution based on OS type, version, and hardware resources. The lab also included **custom facts** under `/etc/ansible/facts.d/`, dynamic variable creation using `set_fact`, and verification using a structured test playbook with assertions.

---

## 🎯 Objectives
By the end of this lab, I was able to:

- Define and use variables in Ansible playbooks
- Gather system information using Ansible facts
- Create conditional tasks based on facts (OS type/version/hardware)
- Implement variable substitution using `{{ }}` templating
- Explain the difference between user-defined variables and system facts
- Apply best practices for variable naming and usage in automation scenarios

---

## 📌 Prerequisites
Before starting this lab, the following knowledge was required:

- Basic understanding of YAML syntax
- Familiarity with Linux command line operations
- Completion of Lab 01–04 (Ansible foundations)
- Understanding of Ansible playbook structure
- Knowledge of SSH key-based authentication

---

## 🖥️ Lab Environment
- **Environment Type:** Cloud lab environment (pre-configured nodes)
- **Control Node:** CentOS/RHEL 8 (Ansible pre-installed)
- **Managed Nodes:** Multiple systems for testing (CentOS + Ubuntu)
- **SSH:** Key-based connectivity pre-configured
- **Inventory:** Existing `inventory` file present in lab directory
- **Working Directory:** `~/lab5-variables-facts`

> ✅ Note: The original lab text required YAML indentation fixes for valid playbooks.  
> This lab also included corrections where certain templating filters or inline template usage would cause runtime errors.

---

## 🗂️ Repository Structure
```text
lab05-variables-and-facts/
├── README.md
├── commands.sh
├── output.txt
├── interview_qna.md
├── troubleshooting.md
└── playbooks/
    └── lab5/
        ├── inventory
        ├── variables-demo.yml
        ├── external-vars-demo.yml
        ├── facts-exploration.yml
        ├── setup-custom-facts.yml
        ├── display-custom-facts.yml
        ├── os-specific-tasks.yml
        ├── version-specific-tasks.yml
        ├── hardware-based-tasks.yml
        ├── variable-precedence.yml
        ├── dynamic-variables.yml
        ├── lab5-verification.yml
        ├── group_vars/
        │   └── all.yml
        └── host_vars/
            └── centos1.yml
````

---

## ✅ Tasks Overview (What I Did)

### ✅ Task 1: Define and Use Variables in Playbooks

* Created a working directory for Lab 5
* Built a playbook (`variables-demo.yml`) demonstrating:

  * string, number, boolean, list, dictionary variables
  * substitution using `{{ variable_name }}`
  * loops using `loop: "{{ required_packages }}"`

### ✅ Task 2: Use External Variable Files

* Created `group_vars/all.yml` to store reusable configuration values
* Created a playbook (`external-vars-demo.yml`) that references variables automatically via inventory group vars
* Verified that values load on all hosts correctly

### ✅ Task 3: Gather and Use Ansible Facts

* Created `facts-exploration.yml` to explore facts:

  * printed full `ansible_facts` for one host only (to avoid huge output across all hosts)
  * printed OS, kernel, CPU, memory
  * printed network facts (IP, interface, gateway)
  * printed disk facts (root filesystem size/available) using safe math conversion

### ✅ Task 4: Create and Use Custom Facts

* Created a playbook (`setup-custom-facts.yml`) to:

  * create `/etc/ansible/facts.d`
  * deploy:

    * `application.fact` (executable script returning JSON)
    * `health.fact` (INI-style facts)
  * refresh facts using `setup:` task
* Created `display-custom-facts.yml` to:

  * read custom facts from `ansible_local.*`
  * print application metadata and system health metrics

### ✅ Task 5: Conditional Logic Based on Facts

* Built OS-specific playbook (`os-specific-tasks.yml`) to:

  * detect OS family and select correct package manager + service name
  * install web server packages depending on OS
  * apply firewall settings (firewalld vs UFW)
  * start/enable web service using `systemd`
* Built version-specific logic (`version-specific-tasks.yml`) to:

  * install Python 3 on CentOS < 8
  * conditionally use `dnf` for newer RedHat systems
  * manage services based on service manager (`systemd` or not)

### ✅ Task 6: Hardware-Aware Automation Using Facts

* Created `hardware-based-tasks.yml` using:

  * memory calculations (GB)
  * low-memory detection
  * multi-core detection
* Generated configuration `/tmp/app_config.conf` based on system resources
* Applied sysctl tuning only for multi-core systems and reloaded sysctl via handler

### ✅ Task 7: Variable Scope, Precedence, and Dynamic Variables

* Built `variable-precedence.yml` to demonstrate:

  * playbook vars
  * host_vars overrides (`host_vars/centos1.yml`)
  * set_fact overriding play vars
  * registering command output (date) and reusing it
  * combining variables with facts
* Built `dynamic-variables.yml` to:

  * generate system profiles using facts
  * create structured dictionaries with derived values
  * generate unique IDs per host using epoch timestamps

### ✅ Task 8: Verification Playbook with Assertions

* Created `lab5-verification.yml` to validate:

  * variable definitions
  * required facts availability
  * conditional logic execution
  * correct output formatting
* Verified successful completion across all hosts

---

## ✅ Verification & Validation

The following checks confirmed successful lab completion:

* ✅ Variables substituted correctly in playbook output
* ✅ External variables loaded via `group_vars/all.yml`
* ✅ Facts gathered and used without errors
* ✅ Root disk and network facts printed correctly
* ✅ Custom facts created under `/etc/ansible/facts.d/` and loaded into `ansible_local`
* ✅ OS-specific logic executed correctly (RedHat vs Debian)
* ✅ Version-based tasks triggered correctly for CentOS 7 (older branch)
* ✅ Hardware-based tuning applied only where appropriate
* ✅ Variable precedence demonstrated: host_vars overrides play vars; set_fact overrides prior value
* ✅ Verification tests passed using `assert`

---

## 🧠 What I Learned

* The difference between:

  * user-defined variables (`vars`, `group_vars`, `host_vars`, `vars_files`)
  * system facts (`ansible_facts`, `ansible_*`)
* How to use facts to make playbooks adaptive and portable
* How to build conditional logic based on:

  * OS family, distribution, version
  * systemd detection
  * hardware resources (CPU/memory)
* How custom facts extend automation with application/system metadata
* How variable precedence affects real-world automation correctness
* How to safely handle undefined vars using `default()`
* How to validate automation logic using structured verification playbooks

---

## 🌍 Why This Matters

Variables and facts enable **intelligent automation**. In real enterprise environments, systems vary by OS, version, and hardware specs. Using facts and structured variables makes playbooks portable, maintainable, and scalable—reducing duplication and preventing configuration drift.

---

## 🧩 Real-World Applications

* Deploying automation across mixed OS fleets (RHEL + Ubuntu)
* Dynamically selecting correct service names, package managers, and configs
* Hardware-aware tuning and configuration generation
* Standardizing environments using `group_vars` and `host_vars`
* Building observability metadata via custom facts
* Implementing safe validation gates using `assert`

---

## ✅ Result

* Variable-based playbooks created and executed successfully
* External vars, host vars, and precedence behaviors demonstrated
* Facts gathered and used for conditional automation
* Custom facts created and validated through `ansible_local`
* Verification playbook confirmed correct lab outcomes

✅ **Lab completed successfully on a cloud lab environment.**
