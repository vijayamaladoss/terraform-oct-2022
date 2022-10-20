resource "random_pet" "rg_name" {
   prefix = var.resource_group_name_prefix
}

resource "azurerm_resource_group" "rg" {
    location = var.resource_group_location
    name = random_pet.rg_name.id
    depends_on = [
        random_pet.rg_name
    ]
}

resource "azurerm_virtual_network" "my_virtual_network" {
    name = "my-virtual-net"
    address_space = ["10.0.0.0/16"]
    location = azurerm_resource_group.rg.location
    resource_group_name = azurerm_resource_group.rg.name
    depends_on = [
        azurerm_resource_group.rg
    ]
}

resource "azurerm_subnet" "my_subnet" {
  name = "mySubnet"
  resource_group_name = azurerm_resource_group.rg.name
  virtual_network_name = azurerm_virtual_network.my_virtual_network.name
  address_prefixes = ["10.0.1.0/24"]

  depends_on = [
    azurerm_resource_group.rg
  ]
}

resource "azurerm_network_security_group" "my-nsg" {
  count = 3
  name = "myNetworkSecurityGroup${count.index}"
  location = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name

  security_rule {
    name = "SSH"    
    priority = "100"
    direction = "Inbound"
    access = "Allow"
    protocol = "Tcp"
    source_port_range = "*"
    destination_port_range = "22"
    source_address_prefix = "*"
    destination_address_prefix = "*"
  }
  security_rule {
    name = "OpenHttpPortOnVM"    
    priority = "200"
    direction = "Inbound"
    access = "Allow"
    protocol = "Tcp"
    source_port_range = "*"
    destination_port_range = "80"
    source_address_prefix = "*"
    destination_address_prefix = "*"
  }
  security_rule {
    name = "OpenICMPPortOnVM"    
    priority = "300"
    direction = "Inbound"
    access = "Allow"
    protocol = "ICMP"
    source_port_range = "*"
    destination_port_range = "*"
    source_address_prefix = "*"
    destination_address_prefix = "*"
  }

  depends_on = [
    azurerm_resource_group.rg
  ]
}

resource "azurerm_public_ip" "my_public_ip" {
  count = 3
  name = "myPublicIP${count.index}"
  location = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  allocation_method = "Dynamic"    
//  sku             = "Standard"

  depends_on = [
    azurerm_resource_group.rg
  ]
}

resource "azurerm_network_interface" "my_nic" {
  count = 3
  name = "myNIC${count.index}"
  location = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name

  ip_configuration {
    name = "my_nic_configuration${count.index}"
    subnet_id = azurerm_subnet.my_subnet.id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id = azurerm_public_ip.my_public_ip[count.index].id
  }  
  depends_on = [
    azurerm_resource_group.rg
  ]
}

resource "azurerm_network_interface_security_group_association"  "nic_ngs_connector" {
  count = 3
  network_interface_id = azurerm_network_interface.my_nic[count.index].id
  network_security_group_id = azurerm_network_security_group.my-nsg[count.index].id
  depends_on = [
    azurerm_resource_group.rg
  ]
}

resource "tls_private_key" "my_ssh_key" {
    algorithm = "RSA"
    rsa_bits = 4096
  depends_on = [
    azurerm_resource_group.rg
  ]
}

#Availability Set - Fault Domains [Rack Resilience]
resource "azurerm_availability_set" "my-avs" {
  name                         = "my-availability-set"
  location                     = azurerm_resource_group.rg.location
  resource_group_name          = azurerm_resource_group.rg.name
  platform_fault_domain_count  = 3 // 3 Different Racks
  platform_update_domain_count = 3 // software updates will happen at different times
  managed                      = true
}

resource "azurerm_linux_virtual_machine" "my_ubuntu_vm" {
  count = 3
  name = "myUbuntuVM${count.index}"
  location = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  network_interface_ids = [azurerm_network_interface.my_nic[count.index].id]
  size = "Standard_DS1_v2"
  availability_set_id   = azurerm_availability_set.my-avs.id
  
  os_disk {
    name = "myHardDisk${count.index}"
    caching = "ReadWrite"
    storage_account_type = "Premium_LRS"
  }

  source_image_reference {
    publisher = "Canonical"
    offer = "UbuntuServer"
    sku = "18.04-LTS"
    version = "latest"
  }

  computer_name = "myvm${count.index}"
  admin_username = "azureuser"
  disable_password_authentication = true

  admin_ssh_key {
    username = "azureuser"
    public_key = tls_private_key.my_ssh_key.public_key_openssh
  }

  provisioner "remote-exec" {
      inline = [
        "sudo apt update && sudo apt install -y nginx",
        "sudo systemctl enable nginx", 
        "sudo systemctl start nginx"
      ]
      on_failure = fail
  }

  connection {
    type = "ssh"
    user = "azureuser"
    private_key = tls_private_key.my_ssh_key.private_key_openssh
    host = self.public_ip_address
  }

  depends_on = [
    azurerm_resource_group.rg, 
    azurerm_network_interface.my_nic,
    azurerm_network_security_group.my-nsg,
    azurerm_network_interface_security_group_association.nic_ngs_connector
  ]
}
