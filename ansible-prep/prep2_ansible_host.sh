#!/bin/bash

#---------------------------------------
# Run on Ansible host/management server.
#---------------------------------------
# Description: 
#   Prepare Ansible server for Proxmox automation. 
#   Install packages and configure Proxmox SSH authentication. 
#   Setup Ansible inventory, config files and directories. 
#   Test connection and authentication to Proxmox.

# Variables
source variables.sh

#----------------------------------------------
# Install necessary packages on Ansible server.
#----------------------------------------------
echo -n "[INFO]: Updating repositories..."
sudo apt-get -qq update
printf " [DONE] \n"
echo -n "[INFO]: Installing required packages..."
sudo apt-get -qq install $ans_req_packages -y
printf " [DONE] \n"

# Setup SSH keys, copy to the Proxmox hosts to allow passwordless authentication.
# Note: Will be prompted for key location, press enter to accept default. 
# Note: Will be prompted to enter key passphrase. 
printf "[INFO]: Generating new SSH keys... \n"
ssh-keygen -q -t rsa -b 4096 -C "ansible" -f ~/.ssh/$ans_sshkey_name

# Copy the public key to the Proxmox servers. 
# Note: Will be prompted for Proxmox server 'ansible' account password.
for ip in "${!proxmox_host_ips[@]}"; do
    printf "[INFO]: Copying Ansible server SSH key to Proxmox server: %s (%s) \n" "${proxmox_host_names[ip]}" "${proxmox_host_ips[ip]}"
    ssh-copy-id -i ~/.ssh/$ans_sshkey_name.pub $ans_user_name@${proxmox_host_ips[ip]}
done
eval `ssh-agent` >/dev/null
ssh-add -q ~/.ssh/$ans_sshkey_name

#--------------------------------------
# Setup Ansible Directories and Files 
#--------------------------------------
echo -n "[INFO]: Setting up required files..."
# Force delete any existing configuration files related to project. 
rm -f inventory ansible.cfg
# Create Ansible configuration file and populate default configuration. 
touch ansible.cfg
printf "[defaults]\ninterpreter_python=auto_silent\nhost_key_checking=False\n" > ansible.cfg
# Create Ansible 'inventory' file to contain Proxmox host details.
touch inventory
printf "[proxmox_hosts]\n" > inventory

# Loop through each Proxmox host from array, add to 'inventory' file. 
for h in "${!proxmox_host_names[@]}"; do
    printf "%s ansible_host=%s ansible_ssh_private_key_file=~/.ssh/ansible\n" "${proxmox_host_names[h]}" "${proxmox_host_ips[h]}" >> inventory
done

# Set Python interpreter path. 
printf "\n[proxmox_hosts:vars]\nansible_python_interpreter=/usr/bin/python3\nansible_ssh_private_key_file=~/.ssh/$ans_sshkey_name\n" >> inventory
printf " [DONE] \n"

#------------------------
# Test/Check Connectivity
#------------------------
# Check access to Proxmox hosts.
#ansible proxmox_hosts -i inventory -m ping --user=root -k
ansible proxmox_hosts -i inventory -m ping --user=$ans_user_name
ansible proxmox_hosts -i inventory -a "uptime" --user=$ans_user_name
echo "------------------------------------------"
echo "Ansible Promxox configuration is complete!"
echo "------------------------------------------"
echo ""

# EOF
