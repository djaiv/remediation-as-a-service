package main

import future.keywords.if

# Fail if any azurerm_storage_container is public.

deny[msg] if {
  some rc in input.resource_changes
  rc.type == "azurerm_storage_container"

  after := rc.change.after
  access := after.container_access_type

  access == "blob"   # public blob access

  msg := sprintf(
    "Storage container %v allows anonymous public access (container_access_type = %v)",
    [rc.name, access],
  )
}
