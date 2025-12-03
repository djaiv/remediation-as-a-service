
package terraform.azure.nsg

deny[msg] {
  r := input.resource_changes[_]
  r.type == "azurerm_network_security_group"
  rule := r.change.after.security_rule[_]
  rule.destination_port_range == "3389"
  rule.source_address_prefix == "*"
  msg := sprintf("NSG %v allows RDP 3389 from ANY", [r.name])
}
