# Day 2

## Install azure-cli in Ubuntu (in RPS Machine)
```
curl -sL https://aka.ms/InstallAzureCLIDeb | sudo bash
sudo apt-get update
sudo apt-get install ca-certificates curl apt-transport-https lsb-release gnupg
AZ_REPO=$(lsb_release -cs)
echo "deb [arch=amd64] https://packages.microsoft.com/repos/azure-cli/ $AZ_REPO main" |
    sudo tee /etc/apt/sources.list.d/azure-cli.list
sudo apt-get update
sudo apt-get install azure-cli
```

### Checking if azure cli tool is installed properly
```
az --version
```

Expected Output
<pre>
<b>jegan@tektutor.org</b>:~/Terraform/Lab1$ <b>az --version</b>
azure-cli                         2.41.0

core                              2.41.0
telemetry                          1.0.8

Dependencies:
msal                            1.20.0b1
azure-mgmt-resource             21.1.0b1

Python location '/opt/az/bin/python3'
Extensions directory '/home/jeganathan/.azure/cliextensions'

Python (Linux) 3.10.5 (main, Oct 10 2022, 03:02:37) [GCC 11.2.0]

Legal docs and information: aka.ms/AzureCliLegal


Your CLI is up-to-date.
</pre>

### Login to azure portal using azure cli
```
az login
```

Expected output
<pre>
<b>jegan@tektutor.org</b>:~/Terraform/Lab1$<b> az login</b>
A web browser has been opened at https://login.microsoftonline.com/organizations/oauth2/v2.0/authorize. Please continue the login in the web browser. If no web browser is available or if the web browser fails to open, use device code flow with `az login --use-device-code`.
[
  {
    "cloudName": "AzureCloud",
    "homeTenantId": "12345678-1234-56ee-4a3c-cd150280z9c2",
    "id": "x112e521-1d23-89c1-nt26-k5s71px5370d",
    "isDefault": true,
    "managedByTenants": [],
    "name": "Free Trial",
    "state": "Enabled",
    "tenantId": "1234jl56-v789-01uw-2x3p-a456sfr789012",
    "user": {
      "name": "abc@xyz.com",
      "type": "user"
    }
  }
]
</pre>

## What is Terraform Module?
- is a set of Terraform configuration files in a single directory
- you may have just a single .tf file or multiple .tf files
- if you run Terraform commands directly from such a directory, it is considered the root module

## What is a Child Module?
 - Terraform commands will only directly use the configuration files in one directory, which is usually the current working directory. 
 - However, your configuration can call modules in other directories. When Terraform encounters a module block, it loads and processes that module's configuration files.
- A module that is called by another configuration is referred to as a "child module" of that configuration.

## Local vs Remote Module
- Modules can either be loaded from the local filesystem, or a remote source. 
- Terraform supports a variety of remote sources, 
  - Terraform Registry, 
  - Version control systems
  - HTTP URLs
  - Terraform Cloud 
  - Terraform Enterprise private module registries

## Lab - Creating docker container on Azure Virtual Machine using Terraform


```
1. Create Azure VM - Ubuntu
2. Download the SSH Key
3. Change permission to the SSH Key
chmod 400 ~/Downloads/your-ssh.key
4. SSH into your Azure VM
ssh -i ~/Downloads/your-ssh-key azureuser@<your-azure-public-ip>
4. Install Docker
sudo apt update && sudo apt install -y docker.io
5. Start the Docker Service
sudo systemctl enable docker
sudo systemctl start docker
sudo systemctl status docker
6. Edit the docker service /lib/systemd/system/docker.service
sudo vim /lib/systemd/system/docker.service +14
7. ExecStart=/usr/bin/dockerd -H fd:// --containerd=/run/containerd/containerd.sock -H tcp://0.0.0.0:4243
8. Restart docker
sudo systemctl daemon-reload
sudo systemctl restart docker
sudo systemctl status docker
9. Press letter 'q' to come out of Docker status
10. Add the currently logged in user to docker user group.  Once you add the user to docker user group, you will be able issue docker commands.
sudo usermod -aG docker $USER
11. newgrp docker
12. docker images
```

## Lab - Terraform Login
Create a file name 'main.tf' with the below content
<pre>
terraform {
  required_providers {
    azurerm = {
      source = "hashicorp/azurerm"
      version = "=3.0.0"
    }
  }
}

provider "azurerm" {
  features {}
  subscription_id = "your-azure-subscription-id"
  tenant_id = "your-azure-tenantid"
}
</pre>

You may now try to login to Azure portal using Terraform
<pre>
terraform init
terraform apply
</pre>


## Lab - Let's create a Azure Resource Group using Terraform 
```
terraform {
  required_providers {
    azurerm = { 
      source = "hashicorp/azurerm"
      version = "=3.0.0"
    }   
  }
}

provider "azurerm" {
  features {}
}

resource "azurerm_resource_group" "tektutor_rg" {
    name = "tektutor_rg"
    location = "West Europe"
}
```

Now let's try creating the resource group
```
terraform init
terraform apply  --auto-approve
```

Expected output
<pre>
(jegan@tektutor.org)$ terraform apply --auto-approve

Terraform used the selected providers to generate the following execution plan. Resource actions are
indicated with the following symbols:
  + create

Terraform will perform the following actions:

  # azurerm_resource_group.tektutor_rg will be created
  + resource "azurerm_resource_group" "tektutor_rg" {
      + id       = (known after apply)
      + location = "westeurope"
      + name     = "tektutor_rg"
    }

Plan: 1 to add, 0 to change, 0 to destroy.
azurerm_resource_group.tektutor_rg: Creating...
azurerm_resource_group.tektutor_rg: Creation complete after 3s [id=/subscriptions/c817e174-6d44-43b3-af91-c8e6cbd6719a/resourceGroups/tektutor_rg]

Apply complete! Resources: 1 added, 0 changed, 0 destroyed.
</pre>

Cleanup
```
terraform destroy --auto-approve
```

Expected output
<pre>
(jegan@tektutor.org)$ terraform destroy
azurerm_resource_group.tektutor_rg: Refreshing state... [id=/subscriptions/c817e174-6d44-43b3-af91-c8e6cbd6719a/resourceGroups/tektutor_rg]

Terraform used the selected providers to generate the following execution plan. Resource actions are
indicated with the following symbols:
  - destroy

Terraform will perform the following actions:

  # azurerm_resource_group.tektutor_rg will be destroyed
  - resource "azurerm_resource_group" "tektutor_rg" {
      - id       = "/subscriptions/c817e174-6d44-43b3-af91-c8e6cbd6719a/resourceGroups/tektutor_rg" -> null
      - location = "westeurope" -> null
      - name     = "tektutor_rg" -> null
      - tags     = {} -> null
    }

Plan: 0 to add, 0 to change, 1 to destroy.

Do you really want to destroy all resources?
  Terraform will destroy all your managed infrastructure, as shown above.
  There is no undo. Only 'yes' will be accepted to confirm.

  Enter a value: yes

azurerm_resource_group.tektutor_rg: Destroying... [id=/subscriptions/c817e174-6d44-43b3-af91-c8e6cbd6719a/resourceGroups/tektutor_rg]
azurerm_resource_group.tektutor_rg: Still destroying... [id=/subscriptions/c817e174-6d44-43b3-af91-c8e6cbd6719a/resourceGroups/tektutor_rg, 10s elapsed]
azurerm_resource_group.tektutor_rg: Still destroying... [id=/subscriptions/c817e174-6d44-43b3-af91-c8e6cbd6719a/resourceGroups/tektutor_rg, 20s elapsed]
azurerm_resource_group.tektutor_rg: Still destroying... [id=/subscriptions/c817e174-6d44-43b3-af91-c8e6cbd6719a/resourceGroups/tektutor_rg, 30s elapsed]
azurerm_resource_group.tektutor_rg: Still destroying... [id=/subscriptions/c817e174-6d44-43b3-af91-c8e6cbd6719a/resourceGroups/tektutor_rg, 40s elapsed]
azurerm_resource_group.tektutor_rg: Still destroying... [id=/subscriptions/c817e174-6d44-43b3-af91-c8e6cbd6719a/resourceGroups/tektutor_rg, 50s elapsed]
azurerm_resource_group.tektutor_rg: Still destroying... [id=/subscriptions/c817e174-6d44-43b3-af91-c8e6cbd6719a/resourceGroups/tektutor_rg, 1m0s elapsed]
azurerm_resource_group.tektutor_rg: Still destroying... [id=/subscriptions/c817e174-6d44-43b3-af91-c8e6cbd6719a/resourceGroups/tektutor_rg, 1m10s elapsed]
azurerm_resource_group.tektutor_rg: Still destroying... [id=/subscriptions/c817e174-6d44-43b3-af91-c8e6cbd6719a/resourceGroups/tektutor_rg, 1m20s elapsed]
azurerm_resource_group.tektutor_rg: Destruction complete after 1m21s

Destroy complete! Resources: 1 destroyed.
</pre>


## Cloing the repository
```
cd ~
git clone https://github.com/tektutor/terraform-oct-2022.git
```

## Lab - Creating a Virtual Machine in Azure using Terraform
```
cd ~/terraform-oct-2022
git pull
cd Day2/azure-vm/

terraform init
terraform apply --auto-approve
```
