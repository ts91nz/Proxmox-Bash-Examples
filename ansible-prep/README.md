# Proxmox Automation: Ansible

Collection of basic Bash scripts to configure Ansible and Proxmox.

Intended for initial setup on new hosts. 

Credit to [UntouchedWagons](https://github.com/UntouchedWagons) for inspiration and command examples. 

Link: https://github.com/UntouchedWagons/Ubuntu-CloudInit-Docs


## File List: 
- prep1_proxmox_host.sh
- prep2_ansible_host.sh
- variables.sh


### prep1_proxmox_host.sh
- Run once configuration PER HOST.
- Configures Proxmox host by installing required packages.
- Creates and configures 'ansible' user account.
- Obtain Ubuntu cloud-init image, resize and prep with 'gemu-agent' and define default creds.
- Create VM and convert to template.


### prep2_ansible_host.sh
- Prepare Ansible server/management host for Proxmox automation. 
- Install packages and configure for Proxmox authentication/SSH. 
- Test configuration by making auth request to get ping and Proxmox hosts uptime. 


### variables.sh
- Contains script variables for both scripts. 
- Read in as 'source' by preparation scripts. 
- Used to make scripts more portable.
