#!/bin/bash
# Lab 01 - Introduction to Ansible
# Commands Executed During Lab (Sequential)

# ================================
# Task 1: Install Ansible
# ================================
sudo apt update
sudo apt install ansible -y
ansible --version

# ================================
# Task 2: Set up Basic Inventory
# ================================
sudo nano /etc/ansible/hosts
sudo cat /etc/ansible/hosts

# ================================
# Task 3: Run Simple Ping Command
# ================================
ansible local -m ping
