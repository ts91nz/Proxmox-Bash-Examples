#!/bin/bash
# Create the VM to be used for the template.
sudo qm create 9990 --name "template-ubuntu-2204-cloudinit" \
  --ostype l26 \
  --memory 1024 --balloon 0 \
  --agent 1 \
  --bios seabios \
  --boot order=scsi0 \
  --scsihw virtio-scsi-pci \
  --scsi0 local-lvm:0,import-from=/var/lib/vz/template/iso/ubuntu-22.04-cloudimg-amd64.img,backup=0,cache=writeback,discard=on \
  --ide2 local-lvm:cloudinit \
  --cpu host --socket 1 --cores 2 \
  --vga virtio \
  --net0 virtio,bridge=vmbr1

# Convert to template.
sudo qm template 9990