#!/bin/bash

#-----------------------
# Run on Proxmox server.
#-----------------------
# Description: 
#   MUST be run on every proxmox node you wish to use Ansible with. 
#   Prepare Proxmox server for Ansible automation.
#   Install packages and create dedicated 'ansible' account.
#   Obtain and prepare cloud-init image.
#   Create VM to be used as template.
#   Ref: https://github.com/UntouchedWagons/Ubuntu-CloudInit-Docs

# Variables
source variables.sh

#----------------------------------------------
# Install necessary packages on Proxmox server.
#----------------------------------------------
# RUN ONCE: Installing libguestfs-tools only required once, prior to first run.
echo -n "[INFO]: Updating repositories..."
apt-get -qq update
printf " [DONE] \n"
echo -n "[INFO]: Installing required packages..."
#apt-get -qq install python3-proxmoxer libguestfs-tools -y
apt-get -qq install $prx_req_packages -y
printf " [DONE] \n"
echo "-----------------------------------------"
echo "Required Package Installations: Complete!"
echo "-----------------------------------------"
echo " "

#-------------------------------------------------------
# Configure 'ansible' user account with sudo privilages.
#-------------------------------------------------------
# Check for existence of 'ansible' user. Create if not present. 
if ! id "$ans_user_name" >/dev/null 2>&1; then
    echo "[WARN]: Ansible user '$(echo $ans_user_name)' not found."
    echo "[INFO]: Creating user '$(echo $ans_user_name)'..."
    sudo useradd -c "Ansible user account." -m $ans_user_name
    adduser $ans_user_name sudo
    touch /etc/sudoers.d/$ans_user_name
    echo "$ans_user_name ALL=(ALL) NOPASSWD:ALL" >> /etc/sudoers.d/$ans_user_name
else
    echo "[INFO]: Ansible user '$(echo $ans_user_name)' exists. Proceed."
fi
passwd $ans_user_name # Set ansible user password. 
echo "-------------------------------------"
echo "Ansible User Configuration: Complete!"
echo "-------------------------------------"
echo " "

# RUN ONCE: Download the current Ubuntu cloud-init disk image.
echo "[INFO]: Downloading Ubuntu cloud-init image..."
wget $cloud_img_file

# RUN ONCE: Resize image as when used in current form, is already at 83% disk used. 
echo "[INFO]: Expanding disk image file..."
sudo qemu-img resize $template_img_file 32G

# RUN ONCE: Modify the image file to install the Qemu Guest Agent. 
echo "[INFO]: Installing the Qemu Guest Agent into image file..."
sudo virt-customize -a $template_img_file --install qemu-guest-agent

# RUN ONCE: Set the default root account credentials.
echo "[INFO]: Setting default root user password..."
sudo virt-customize -a $template_img_file --root-password password:$template_rootpw

# Move to Proxmox ISO location.
echo "[INFO]: Moving image file to Proxmox storage..."
sudo mv -f $template_img_file $template_img_path

# Create the VM to be used for the template.
echo "[INFO]: Creating VM from cloud-init image..."
sudo qm create $template_id --name "$template_name" \
  --ostype l26 \
  --memory 1024 --balloon 0 \
  --agent 1 \
  --bios seabios \
  --boot order=scsi0 \
  --scsihw virtio-scsi-pci \
  --scsi0 local-lvm:0,import-from=$template_img_path,backup=0,cache=writeback,discard=on \
  --ide2 local-lvm:cloudinit \
  --cpu host --socket 1 --cores 2 \
  --vga virtio \
  --net0 virtio,bridge=vmbr0

# Convert to template.
echo "[INFO]: Converting VM to template..."
sudo qm template $template_id

echo "-------------------------------------"
echo "Template image preparation: Complete!"
echo "-------------------------------------"
echo " "