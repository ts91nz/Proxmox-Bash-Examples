#!/bin/bash

#----------------#
# Variables File #
#----------------#
# Description: 
#   Referenced by scripts to import variables. 
#   Keep all required variables in one place.

# Proxmox Setup
prx_req_packages="python3-proxmoxer libguestfs-tools git" # Required packages to install.
ans_user_name="ansible" # New user for Ansible.
prx_root_account="root" # Proxmox server root account.
proxmox_host_names=(
    "tst-hvr-pve01" 
    "tst-hvr-pve02"
)
proxmox_host_ips=(
    "10.0.0.100" 
    "10.0.0.101"
)

# Proxmox Template Config
cloud_img_name="jammy-server-cloudimg-amd64"
cloud_img_file="https://cloud-images.ubuntu.com/jammy/current/$cloud_img_name.img"
template_id=9000
template_name="ztmp-ubuntu-cloudinit-2c-1gb-32g"
template_rootpw="changeMe123!"
template_img_file="$cloud_img_name.img"
template_img_path="/var/lib/vz/template/iso/$template_img_file"

# Ansible Setup
ans_req_packages="sshpass ansible python3-proxmoxer gh"
project_dir="proxmox-ansible-automation"
ans_sshkey_name="ansible"

# EOF
