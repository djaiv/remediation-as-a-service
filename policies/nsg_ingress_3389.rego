package terraform.azure.nsg

# Fail if any NSG allows inbound RDP 3389 from any source.

deny contains msg if {
  some rc in input.resource_changes
  rc.type == "azurerm_network_security_group"

  after := rc.change.after

  some rule in after.security_rule

  rule.direction == "Inbound"
  rule.access == "Allow"
  rule.protocol == "Tcp"
  rule.destination_port_range == "3389"
  rule.source_address_prefix == "*"

  msg := sprintf(
    "NSG %v allows RDP 3389 from any source (rule: %v)",
    [rc.name, rule.name],
  )
}
