package terraform.azure.nsg

# Detect any NSG rule that allows inbound RDP (3389) from any source.

deny[msg] {
  rc := input.resource_changes[_]
  rc.type == "azurerm_network_security_group"

  rule := rc.change.after.security_rule[_]

  # Inbound allow on TCP 3389 from any
  rule.direction == "Inbound"
  rule.access == "Allow"
  rule.protocol == "Tcp"
  rule.destination_port_range == "3389"
  rule.source_address_prefix == "*"

  msg := sprintf("NSG %v allows RDP 3389 from any source (rule: %v)", [rc.name, rule.name])
}
