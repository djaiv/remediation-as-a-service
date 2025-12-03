package terraform.azure.nsg

# Flag any NSG rule that allows inbound RDP 3389 from any source.

deny contains msg if {
  some res in input.planned_values.root_module.resources
  res.type == "azurerm_network_security_group"

  some rule in res.values.security_rule

  rule.direction == "Inbound"
  rule.access == "Allow"
  rule.protocol == "Tcp"
  rule.destination_port_range == "3389"
  rule.source_address_prefix == "*"

  msg := sprintf(
    "NSG %v allows RDP 3389 from any source (rule: %v)",
    [res.name, rule.name],
  )
}
