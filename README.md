# Proxmox-Bash-Examples
Collection of basic Bash scripts to create Proxmox templates and VMs for example purposes.

Credit to 'UntouchedWagons' for inspiration and command examples. 
Link: https://github.com/UntouchedWagons/Ubuntu-CloudInit-Docs

### 0_Prepare-Proxmox-Host.sh
- Run once configuration. 
- Configures Proxmox host by installing required packages.
- Obtain cloud-init image, resize and prep with 'gemu-agent' and define default creds.

### 1_Create-Template.sh
- Create initial VM to be converted into a template.
- Modify VM specifics (cpu/mem etc) as required.
- Convert VM to template.

### 2_Create-VM.sh
- Create a single VM by cloning the template.
- Cloud-Init: Define networking paramters (ip, gw, dns).
- Cloud-Init: Add SSH key for remote access.

### 3_Create-VM-Multiple.sh
- Generate mutliple VMs from defined array.
- Loop each deployment, iterating with through array to append IP address.

