#!/usr/bin/env bash

# Set your private key
declare priv_key="$HOME/.ssh/id_ed25519_voorn"
declare ssh_user="vagrant" # change this first!

declare -a servers_to_manager=(
    "172.23.18.20" # Vagrant test box
    # "161.97.84.130" # Example IP
)

scp_prep_host_script() {
    read -rp "Insert username: " ssh_user
    for server in "${servers_to_manager[@]}"; do
        printf "Copying create_ansible_user.sh to %s\n" "${server}"
        scp -i "${priv_key}" "create_ansible_user.sh" "${ssh_user}"@"${server}":"/tmp/create_ansible_user.sh"
        ssh -t -i "${priv_key}" "${ssh_user}"@"${server}" "sudo chmod +x /tmp/create_ansible_user.sh && sudo bash /tmp/create_ansible_user.sh"
        printf "Done with server %s\n" "${server}"
    done
}

scp_prep_host_script
