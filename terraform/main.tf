resource "azurerm_resource_group" "demo" {
  name     = var.resource_group_name
  location = var.location
}

resource "azurerm_storage_account" "sa" {
  name                     = var.storage_account_name
  resource_group_name      = azurerm_resource_group.demo.name
  location                 = azurerm_resource_group.demo.location
  account_tier             = "Standard"
  account_replication_type = "LRS"

  # risky at account level in some provider versions
  # keep this if your provider supports it and it validates
  # allow_blob_public_access = true
}

# risky container config for the demo
resource "azurerm_storage_container" "sa" {
  name                  = "public-container"
  storage_account_name  = azurerm_storage_account.sa.name
  container_access_type = "private"   # allows anonymous blob access
}

resource "azurerm_network_security_group" "nsg" {
  name                = "nsg-demo"
  location            = azurerm_resource_group.demo.location
  resource_group_name = azurerm_resource_group.demo.name

  security_rule {
    name                       = "rdp-anywhere"
    priority                   = 100
    direction                  = "Inbound"
    access                     = "Deny"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "3389"
    source_address_prefix      = "VirtualNetwork"
    destination_address_prefix = "*"
  }
}
