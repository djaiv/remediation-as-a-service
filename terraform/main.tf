
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

  # risky - allow public blob access for demo
  # Note: 'allow_blob_public_access' is not a valid attribute for azurerm_storage_account in some provider versions.
  # To allow public blob access, configure it within the 'azurerm_storage_container' resource as follows:

  resource "azurerm_storage_container" "sa" {
    name                  = "public-container"
    storage_account_name  = azurerm_storage_account.sa.name
    container_access_type = "blob"
  }

}

resource "azurerm_network_security_group" "nsg" {
  name                = "nsg-demo"
  location            = azurerm_resource_group.demo.location
  resource_group_name = azurerm_resource_group.demo.name

  security_rule {
    name                       = "rdp-anywhere"
    priority                   = 100
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "3389"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }
}
