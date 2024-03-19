#!/bin/bash
# Create the VMs.

# Variables
startVMID=101
vmList=(
	"tst-svr-mgt01" 
	"tst-svr-pwm01" 
	"tst-svr-mon01"
)
for vm in ${!vmList[@]}; do
  echo "Creating VM ${vm}: ${vmList[$vm]} (${startVMID})"
  
  sudo qm create ${startVMID} --name "${vmList[$vm]}" \
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
# Set VM network config, interating the IP address using "vm" counter variable.
  sudo qm set ${startVMID} --ipconfig0 "ip=10.0.10.1${vm}/24,gw=10.0.10.1"
  sudo qm set ${startVMID} --nameserver="10.0.10.1 8.8.8.8"
  sudo qm set ${startVMID} --searchdomain="infra"
  sudo qm set ${startVMID} --sshkey ~/.ssh/id_rsa.pub
  echo "Complete: ${vmList[$vm]}"
  echo ""
  
  ((startVMID++))
done