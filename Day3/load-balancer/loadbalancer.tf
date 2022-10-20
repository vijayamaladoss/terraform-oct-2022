resource "azurerm_public_ip" "lb_public_ip" {
  name                = "PublicIPForLB"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  allocation_method   = "Static"
  sku                 = "Standard"
}

resource "azurerm_lb" "my_lb" {
  name                = "MyLoadBalancer"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  sku                 = "Standard"
  sku_tier            = "Global" //Other option is Global, Regional is default value
  frontend_ip_configuration {
    name                 = "PublicIPAddress"
    public_ip_address_id = azurerm_public_ip.lb_public_ip.id
  }

  depends_on = [
    azurerm_resource_group.rg
  ]
}

resource "azurerm_lb_backend_address_pool" "lb_backend" {
  loadbalancer_id = azurerm_lb.my_lb.id
  name            = "LBBackEndAddressPool"
}

/*
resource "azurerm_network_interface_backend_address_pool_association" "vm_backend" {
  count=3
  network_interface_id = azurerm_network_interface.my_nic.*.id[count.index]
  ip_configuration_name= azurerm_network_interface.my_nic.*.ip_configuration.0.name[count.index]
  backend_address_pool_id = azurerm_lb_backend_address_pool.lb_backend.id
}
*/

resource "azurerm_lb_backend_address_pool_address" "lb_backend_vm_ips" {
  count = 3
  name                                = "vm${count.index}-private-address"
  backend_address_pool_id             = azurerm_lb_backend_address_pool.lb_backend.id
  virtual_network_id = azurerm_virtual_network.my_virtual_network.id
  ip_address = azurerm_linux_virtual_machine.my_ubuntu_vm[count.index].private_ip_address
}

//This rule forwards user traffic received by LB at Port 80 to VM port 80
resource "azurerm_lb_rule" "lb_rule" {
  resource_group_name = azurerm_resource_group.rg.name

  loadbalancer_id                = azurerm_lb.my_lb.id
  name                           = "Http"
  protocol                       = "Tcp"
  frontend_port                  = 80
  backend_port                   = 80
  frontend_ip_configuration_name = "PublicIPAddress"
}

resource "azurerm_lb_probe" "lb_probe_80" {
  resource_group_name = azurerm_resource_group.rg.name

  loadbalancer_id                = azurerm_lb.my_lb.id
  name                           = "LB-Probe-Port-80"
  port                           = 80
  depends_on = [
    azurerm_lb.my_lb
  ]
}
