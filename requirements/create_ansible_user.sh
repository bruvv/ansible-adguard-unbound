#!/usr/bin/env bash

# Ensure user 'ansible' exists on remote host
ensure_local_ansible_user() {
    local -a public_keys=(
        "paste key here"
    )

    if ! id -u ansible >/dev/null 2>&1; then
        printf "Creating user 'ansible'\n"
        groupadd ansible
        useradd ansible -s /bin/bash -m -g ansible
        mkdir -p /home/ansible/.ssh
        touch /home/ansible/.ssh/authorized_keys
        for key in "${public_keys[@]}"; do
            printf "%s\n" "${key}" >>/home/ansible/.ssh/authorized_keys
        done
        chown -R ansible:ansible /home/ansible
        chmod 700 /home/ansible/.ssh
        chmod 600 /home/ansible/.ssh/authorized_keys
        chmod 700 /home/ansible/.ssh/
        # Allow ansible to sudo without password
        printf "ansible ALL=(ALL) NOPASSWD: ALL\n" | sudo tee -a /etc/sudoers.d/ansible
    else
        printf "Ansible user exists already no need for the script to run again.\n"
    fi
}

ensure_local_ansible_user
