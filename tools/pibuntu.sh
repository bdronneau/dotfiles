#!/usr/bin/env bash

set -o nounset -o pipefail -o errexit

if [[ $# -eq 0 ]] ; then
    echo "Error: Usage ./pibuntu.sh hostname"
    exit 1
fi

if [ `whoami` != root ]; then
    echo "Please run this script as root or using sudo"
    exit
fi

# Hostname
cHostname=$(hostname)
hostnamectl set-hostname $1
sed -i "s/${cHostname}/$1/" /etc/hosts

# Time
timedatectl set-timezone Europe/Paris

# User
useradd automation -m -G sudo -s /bin/bash -p $(openssl passwd -crypt $2)
sudo -u automation mkdir /home/automation/.ssh
curl -sfl https://github.com/bdronneau.keys | sudo -u automation tee /home/automation/.ssh/authorized_keys
sudo -u automation chmod 0600 /home/automation/.ssh/authorized_keys

# Disable default login
usermod -L -s /usr/sbin/nologin ubuntu
