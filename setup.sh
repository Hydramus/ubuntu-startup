#!/bin/bash
set -e

echo "**** Begin installing Ubuntu, etc"

install_basic_packages() {
    sudo apt-get update -y
    sudo DEBIAN_FRONTEND=noninteractive apt-get install -y wget net-tools terminator gpg curl libplist-utils gnupg software-properties-common apt-transport-https git vim htop tmux tcpdump nmap wireshark
}

configure_ansible() {
    sudo apt-add-repository --yes --update ppa:ansible/ansible
    sudo apt-get install -y ansible
}

run_ansible_playbooks() {
    for playbook in \
        setup-playbook.yml \
        jetbrains-toolbox.yml \
        vscode-extensions.yml
    do
        ansible-playbook "./$playbook"
    done
}


#adding config file to confirm that non-admins can scan
echo "wireshark-common wireshark-common/install-setuid boolean true" | sudo debconf-set-selections

install_basic_packages
configure_ansible
run_ansible_playbook

echo "Setup Complete!"
