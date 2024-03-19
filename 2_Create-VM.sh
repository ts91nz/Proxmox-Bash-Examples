#!/bin/bash
# Deploy a clone from template.
sudo qm clone 9990 101 --name tst-svr-01

# Configure the SSH public key used for authentication, and configure the IP setup.
sudo qm set 101 --ipconfig0 "ip=10.0.10.15/24,gw=10.0.10.1"
sudo qm set 101 --nameserver="10.0.10.1 8.8.8.8"
sudo qm set 101 --searchdomain="infra"
sudo qm set 101 --sshkey ~/.ssh/id_rsa.pub
echo "Create VM: Complete!"