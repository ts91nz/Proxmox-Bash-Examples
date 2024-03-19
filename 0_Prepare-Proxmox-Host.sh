#!/bin/bash
# Ref: https://github.com/UntouchedWagons/Ubuntu-CloudInit-Docs

# RUN ONCE: Installing libguestfs-tools only required once, prior to first run.
sudo apt update -y
sudo apt install libguestfs-tools -y

# RUN ONCE: Download the current Ubuntu cloud-init disk image and move to ISO location:
wget -q https://cloud-images.ubuntu.com/jammy/current/jammy-server-cloudimg-amd64.img
sudo mv jammy-server-cloudimg-amd64.img /var/lib/vz/template/iso/ubuntu-22.04-cloudimg-amd64.img

# RUN ONCE: Resize image as when used in current form, is already at 83% disk used. 
sudo qemu-img resize jammy-server-cloudimg-amd64.img 32G

# RUN ONCE: Modify the image file to install the Qemu Guest Agent. 
sudo virt-customize -a /var/lib/vz/template/iso/ubuntu-22.04-cloudimg-amd64.img --install qemu-guest-agent

# RUN ONCE: Set the default credentials.
sudo virt-customize -a /var/lib/vz/template/iso/ubuntu-22.04-cloudimg-amd64.img --root-password password:rootPassword!
echo "Host and Image Preparation: Complete!"