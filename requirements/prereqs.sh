#!/usr/bin/env bash
# Functions
check_if_ansible_ppa_installed() {
  check_which_os
  if [[ $PACK_MAN = brew ]]; then
    brew install ansible
  elif [[ $PACK_MAN = dnf ]]; then
    dnf install ansible
  else
    if ! grep -q "ansible" /etc/apt/sources.list /etc/apt/sources.list.d/*; then
      printf "Installing Ansible PPA\n"
      sudo apt-add-repository ppa:ansible/ansible
      sudo apt-get update
    fi
  fi
}

check_which_os() {
  if [[ ! -x "$(command -v apt)" ]]; then
    PACK_MAN="dnf"
  elif [[ ! -x "$(command -v brew)" ]]; then
    PACK_MAN="brew"
  else
    PACK_MAN="apt"
  fi
}

check_if_ansible_binary_availabe() {
  if ! command -v ansible >/dev/null 2>&1; then
    printf "Ansible is not installed or not in the PATH, installing it.\n"
    check_if_ansible_ppa_installed
    check_which_os
    if [[ $PACK_MAN = brew ]]; then
      brew install ansible
    elif [[ $PACK_MAN = dnf ]]; then
      dnf install ansible
    else
      apt install ansible
    fi
  fi
}

check_if_virtualbox_binary_availabe() {
  if ! command -v virtualbox >/dev/null 2>&1; then
    printf "VirtualBox is not installed or not in the PATH, installing it.\n"
    check_which_os
    if [[ $PACK_MAN = brew ]]; then
      brew install virtualbox
    elif [[ $PACK_MAN = dnf ]]; then
      dnf install virtualbox
    else
      apt install virtualbox
    fi
  fi
}

check_if_vagrant_binary_available() {
  if ! command -v vagrant >/dev/null 2>&1; then
    printf "Vagrant is not installed or not in the PATH, installing it.\n"
    check_which_os
    if [[ $PACK_MAN = brew ]]; then
      brew install vagrant
    elif [[ $PACK_MAN = dnf ]]; then
      dnf install vagrant
    else
      apt install vagrant
    fi
  fi
}

check_if_ansible_collection_is_installed() {
  ansible-galaxy install -r requirements.yml
}

run_pip_installers() {
  pip3 install -r requirements.txt
}

main() {
  if [ "$EUID" -ne 0 ]; then
    echo "Please run as root"
    exit
  fi
  check_if_ansible_binary_availabe
  check_if_virtualbox_binary_availabe
  check_if_vagrant_binary_available
  check_if_ansible_collection_is_installed
  #run_pip_installers
}

main
