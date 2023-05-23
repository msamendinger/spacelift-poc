locals {
  exit_command_map = {
    "Reboot" : { command : "reboot", message : "Rebooting in 15 seconds" },
    "Shutdown" : { command : "poweroff", message : "Powering off in 15 seconds" }
  }

  process_exit_command = var.process_exit_behavior == "None" ? "" : <<EOF
echo "${local.exit_command_map[var.process_exit_behavior].message}" >> /var/log/spacelift/error.log
sleep 15
${local.exit_command_map[var.process_exit_behavior].command}
  EOF

  worker_script_head = <<EOF
#!/bin/bash
spacelift () {(
set -e
  EOF

  image_preperation = <<EOF
# /opt/spacelift is Spacelift launcher's scratch space.
sudo mkdir -p /opt/spacelift
# /var/log/spacelift is where Spacelift launcher sends its logs.
sudo mkdir -p /var/log/spacelift
sudo apt-get -y update

sudo apt-get -y install \
    apt-transport-https \
    ca-certificates \
    curl \
    gnupg \
    lsb-release \
    jq

# Add Docker's GPG key
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /usr/share/keyrings/docker-archive-keyring.gpg

# Setup the Docker APT repository
echo \
  "deb [arch=amd64 signed-by=/usr/share/keyrings/docker-archive-keyring.gpg] https://download.docker.com/linux/ubuntu \
  $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null

sudo apt-get -y update

sudo apt-get -y install docker-ce docker-ce-cli containerd.io

# Install gVisor

CURRENTARCH=$(uname -m)
URL=https://storage.googleapis.com/gvisor/releases/release/latest/"$CURRENTARCH"

wget "URL"/runsc "URL"/runsc.sha512 "URL"/containerd-shim-runsc-v1 "URL"/containerd-shim-runsc-v1.sha512
sha512sum -c runsc.sha512 -c containerd-shim-runsc-v1.sha512
rm -f *.sha512

chmod a+rx runsc containerd-shim-runsc-v1
sudo mv runsc containerd-shim-runsc-v1 /usr/local/bin

sudo /usr/local/bin/runsc install -- --fsgofer-host-uds
sudo systemctl restart docker

# Install azure cli
curl -sL https://packages.microsoft.com/keys/microsoft.asc |
    gpg --dearmor |
    sudo tee /etc/apt/trusted.gpg.d/microsoft.gpg > /dev/null
AZ_REPO=$(lsb_release -cs)
echo "deb [arch=amd64] https://packages.microsoft.com/repos/azure-cli/ $AZ_REPO main" |
    sudo tee /etc/apt/sources.list.d/azure-cli.list

sudo apt-get -y update
sudo apt-get -y install azure-cli
  EOF

  worker_script_tail = <<EOF
export SPACELIFT_TOKEN=${spacelift_worker_pool.mbm.config}
export SPACELIFT_POOL_PRIVATE_KEY=${tls_private_key.workers.private_key_pem}

currentArch=$(uname -m)

if [[ "$currentArch" != "x86_64" && "$currentArch" != "aarch64" ]]; then
  echo "Unsupported architecture: $currentArch" >> /var/log/spacelift/error.log
  return 1
fi

baseURL="https://downloads.spacelift.io/spacelift-launcher"
binaryURL=$(printf "%s-%s" "$baseURL" "$currentArch")
shaSumURL=$(printf "%s-%s_%s" "$baseURL" "$currentArch" "SHA256SUMS")
shaSumSigURL=$(printf "%s-%s_%s" "$baseURL" "$currentArch" "SHA256SUMS.sig")

echo "Updating packages" >> /var/log/spacelift/info.log
unattended-upgrade -d 1>>/var/log/spacelift/info.log 2>>/var/log/spacelift/error.log

echo "Downloading Spacelift launcher" >> /var/log/spacelift/info.log
curl "$binaryURL" --output /usr/bin/spacelift-launcher 2>>/var/log/spacelift/error.log
echo "Importing public GPG key" >> /var/log/spacelift/info.log
curl https://keys.openpgp.org/vks/v1/by-fingerprint/175FD97AD2358EFE02832978E302FB5AA29D88F7 | gpg --import 2>>/var/log/spacelift/error.log
echo "Downloading Spacelift launcher checksum file and signature" >> /var/log/spacelift/info.log
curl "$shaSumURL" --output spacelift-launcher_SHA256SUMS 2>>/var/log/spacelift/error.log
curl "$shaSumSigURL" --output spacelift-launcher_SHA256SUMS.sig 2>>/var/log/spacelift/error.log
echo "Verifying checksum signature..." >> /var/log/spacelift/info.log
gpg --verify spacelift-launcher_SHA256SUMS.sig 1>>/var/log/spacelift/info.log 2>>/var/log/spacelift/error.log
retStatus=$?
if [ $retStatus -eq 0 ]; then
    echo "OK\!" >> /var/log/spacelift/info.log
else
    return $retStatus
fi
CHECKSUM=$(cut -f 1 -d ' ' spacelift-launcher_SHA256SUMS)
rm spacelift-launcher_SHA256SUMS spacelift-launcher_SHA256SUMS.sig
LAUNCHER_SHA=$(sha256sum /usr/bin/spacelift-launcher | cut -f 1 -d ' ')
echo "Verifying launcher binary..." >> /var/log/spacelift/info.log
if [[ "$CHECKSUM" == "$LAUNCHER_SHA" ]]; then
  echo "OK\!" >> /var/log/spacelift/info.log
else
  echo "Checksum and launcher binary hash did not match" >> /var/log/spacelift/error.log
  return 1
fi
echo "Making the Spacelift launcher executable" >> /var/log/spacelift/info.log
chmod 755 /usr/bin/spacelift-launcher 2>>/var/log/spacelift/error.log

# Get instance metadata
echo "Retrieving Azure VM Name" >> /var/log/spacelift/info.log
export SPACELIFT_METADATA_instance_id=$(curl -s -H Metadata:true --noproxy "*" "http://169.254.169.254/metadata/instance?api-version=2021-02-01" | jq -r ".compute.name")
echo "Retrieving Azure VM Resource ID" >> /var/log/spacelift/info.log
export SPACELIFT_METADATA_vm_resource_id=$(curl -s -H Metadata:true --noproxy "*" "http://169.254.169.254/metadata/instance?api-version=2021-02-01" | jq -r ".compute.resourceId")
echo "Retrieving Azure VMSS Name" >> /var/log/spacelift/info.log
export SPACELIFT_METADATA_vmss_name=$(curl -s -H Metadata:true --noproxy "*" "http://169.254.169.254/metadata/instance?api-version=2021-02-01" | jq -r ".compute.vmScaleSetName")

echo "Starting the Spacelift binary" >> /var/log/spacelift/info.log
/usr/bin/spacelift-launcher 1>>/var/log/spacelift/info.log 2>>/var/log/spacelift/error.log
)}

spacelift

${local.process_exit_command}
  EOF

  worker_script = base64encode(
    join("\n", [
      local.worker_script_head,
      local.image_preperation,
      local.worker_script_tail,
    ])
  )

  user_data = <<EOF
#!/bin/bash

# Write the launcher script out to a file in the `per-boot` folder to ensure it restarts if the VM is rebooted
echo "${local.worker_script}" | base64 --decode > /var/lib/cloud/scripts/per-boot/spacelift-boot.sh
chmod 744 /var/lib/cloud/scripts/per-boot/spacelift-boot.sh

/var/lib/cloud/scripts/per-boot/spacelift-boot.sh
  EOF
}

resource "azurerm_virtual_network" "spacelift-worker" {
  name                = "spacelift-worker-network"
  address_space       = ["10.0.0.0/16"]
  location            = azurerm_resource_group.spacelift-foundation.location
  resource_group_name = azurerm_resource_group.spacelift-foundation.name
}

resource "azurerm_subnet" "spacelift-worker" {
  name                 = "internal"
  resource_group_name  = azurerm_resource_group.spacelift-foundation.name
  virtual_network_name = azurerm_virtual_network.spacelift-worker.name
  address_prefixes     = ["10.0.2.0/24"]
}

resource "azurerm_network_interface" "spacelift-worker" {
  name                = "spacelift-worker-nic"
  location            = azurerm_resource_group.spacelift-foundation.location
  resource_group_name = azurerm_resource_group.spacelift-foundation.name

  ip_configuration {
    name                          = "internal"
    subnet_id                     = azurerm_subnet.spacelift-worker.id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = azurerm_public_ip.spacelift-worker.id
  }

  lifecycle {
    create_before_destroy = true
  }
}

resource "azurerm_public_ip" "spacelift-worker" {
  name                = "spacelift-worker-public-ip"
  resource_group_name = azurerm_resource_group.spacelift-foundation.name
  location            = azurerm_resource_group.spacelift-foundation.location
  allocation_method   = "Static"
}

resource "azurerm_linux_virtual_machine" "spacelift-worker" {
  name                = "spacelift-worker"
  resource_group_name = azurerm_resource_group.spacelift-foundation.name
  location            = azurerm_resource_group.spacelift-foundation.location
  size                = "Standard_F2"
  admin_username      = "adminuser"
  network_interface_ids = [
    azurerm_network_interface.spacelift-worker.id,
  ]

  admin_ssh_key {
    username   = "adminuser"
    public_key = file("/mnt/workspace/azure.pub")
  }

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  source_image_reference {
    publisher = "Canonical"
    offer     = "0001-com-ubuntu-server-focal-daily"
    sku       = "20_04-daily-lts-gen2"
    version   = "latest"
  }

  custom_data = base64encode(local.user_data)

  identity {
    type = "SystemAssigned"
  }
}

