# 🎤 interview_qna.md — Lab 13: Automating Network Configuration (Ansible)

## 1) Why use Ansible for network configuration instead of manual changes?
Ansible provides **repeatability, consistency, and scalability**. Manual changes are error-prone and difficult to audit. With Ansible, network configuration becomes **infrastructure as code**, easy to version-control and reapply across many systems.

---

## 2) What is the `community.general.nmcli` module used for?
It manages **NetworkManager connections** through Ansible. It can configure:
- static IP addresses  
- gateways  
- DNS servers/search domains  
- routes  
- connection state (up/down)

---

## 3) Why did you install `community.general` collection?
Because `nmcli` in this lab is provided via `community.general`. Even if Ansible is installed, extra collections may not be included by default, so we installed it using:
- `ansible-galaxy collection install community.general`

---

## 4) What is the difference between `ip addr show` and `nmcli connection show`?
- `ip addr show` displays **current runtime interface state** and assigned IPs.
- `nmcli connection show` displays **NetworkManager connection profiles** (configured connections), whether or not they are active.

---

## 5) Why did you use handlers like `restart_network` or reload connection?
Network changes often require a **service restart** or **connection reload** to take effect consistently.  
Handlers ensure services are restarted **only when changes occur**, which is a best practice in Ansible.

---

## 6) Why did you create a separate `inventory` file for this lab?
It makes the lab reproducible and isolated. The inventory defines:
- which hosts are managed
- SSH connection variables
- reusable group structure  
This avoids relying on global/system inventory and keeps the lab self-contained.

---

## 7) What does it mean that `secondary-net` showed `DEVICE --`?
That indicates the profile exists but is **not active** (not bound to a device currently). NetworkManager can store multiple profiles for the same interface, but only one profile is active at a time unless advanced routing or policy routing is used.

---

## 8) How did you verify that static IP changes were applied successfully?
By running:
- `ansible -i inventory all -m shell -a "ip addr show"`
and checking that:
- node1 changed to `192.168.1.100/24`
- node2 changed to `192.168.1.101/24`

---

## 9) How did you apply routing changes and verify them?
Routing changes were applied through:
- `community.general.nmcli` routes settings  
and written to:
- `/etc/sysconfig/network-scripts/route-eth0` (for persistence)

Verified using:
- `ip route show`

---

## 10) Why is DNS configuration automation important?
DNS misconfiguration can break updates, service discovery, and internal applications. Automation ensures:
- consistent DNS across all systems
- faster troubleshooting
- predictable resolution behavior
- compliance with enterprise standards

---

## 11) What is the purpose of templating `/etc/resolv.conf` using Jinja2?
Templating ensures consistent file formatting and supports variables like:
- list of search domains
- multiple DNS servers  
Using templates also makes future updates simple (change variables, rerun playbook).

---

## 12) Why did you fetch reports back to the control node?
In enterprise automation, it’s valuable to generate **audit evidence** and centralized documentation. Using `fetch` creates:
- per-host reports
- stored centrally
- easy to attach to tickets/change requests or compliance reports

---

## 13) What did the master playbook demonstrate?
It demonstrated combining multiple network automation tasks into a single workflow:
- set primary profile
- add routes
- validate gateway reachability
- test DNS resolution for multiple domains

---

## 14) What common issue can break nmcli automation?
If NetworkManager isn’t running, `nmcli` operations fail. The fix is ensuring the service is started/enabled:
- `ansible ... -m service -a "name=NetworkManager state=started enabled=yes" --become`

---

## 15) How does this lab connect to real-world DevOps / SysOps work?
This lab mirrors how teams manage network baselines across environments:
- provisioning new servers
- applying consistent IP/DNS/route policies
- validating changes automatically
- producing reports for auditing and operational visibility
