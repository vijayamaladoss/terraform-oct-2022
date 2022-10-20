resource "azurerm_public_ip" "lb-public-ip" {
  name                = "PublicIPForLB"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  allocation_method   = "Static"
  sku                 = "Standard"
}

resource "azurerm_lb" "lb" {
  name                = "LoadBalancer"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  sku = "Standard"

  frontend_ip_configuration {
    name                 = "PublicIPAddress"
    public_ip_address_id = azurerm_public_ip.lb-public-ip.id
  }
}

resource "azurerm_lb_backend_address_pool" "backend-address-pool" {
  loadbalancer_id = azurerm_lb.lb.id
  name            = "BackEndAddressPool"
}

resource "azurerm_lb_backend_address_pool_address" "vm1-ip" {
  name                    = "vm1-ip"
  backend_address_pool_id = azurerm_lb_backend_address_pool.backend-address-pool.id
  virtual_network_id      = azurerm_virtual_network.my_virtual_network.id
  ip_address              = azurerm_linux_virtual_machine.my_ubuntu_vm[0].private_ip_address 
}

resource "azurerm_lb_backend_address_pool_address" "vm2-ip" {
  name                    = "vm2-ip"
  backend_address_pool_id = azurerm_lb_backend_address_pool.backend-address-pool.id
  virtual_network_id      = azurerm_virtual_network.my_virtual_network.id
  ip_address              = azurerm_linux_virtual_machine.my_ubuntu_vm[1].private_ip_address 
}

resource "azurerm_lb_backend_address_pool_address" "vm3-ip" {
  name                    = "vm3-ip"
  backend_address_pool_id = azurerm_lb_backend_address_pool.backend-address-pool.id
  virtual_network_id      = azurerm_virtual_network.my_virtual_network.id
  ip_address              = azurerm_linux_virtual_machine.my_ubuntu_vm[2].private_ip_address 
}

resource "azurerm_lb_probe" "lb-health-check" {
  resource_group_name = azurerm_resource_group.rg.name
  loadbalancer_id = azurerm_lb.lb.id
  name            = "LBHealthCheck"
  port            = 80 
}

resource "azurerm_lb_rule" "lb-rule" {
  resource_group_name = azurerm_resource_group.rg.name
  loadbalancer_id                = azurerm_lb.lb.id
  name                           = "LBRule"
  protocol                       = "Tcp"
  frontend_port                  = 80 
  backend_port                   = 80 
  frontend_ip_configuration_name = "PublicIPAddress"
}

resource "azurerm_lb_probe" "lb-probe" {
  resource_group_name = azurerm_resource_group.rg.name
  loadbalancer_id = azurerm_lb.lb.id
  protocol        = "Http"
  name            = "vm-probe"
  port            = 80 
  request_path    = "/"
}
