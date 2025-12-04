package main

import rego.v1

# Fail if any azurerm_storage_container is public.

deny contains msg if {
  some rc in input.resource_changes
  rc.type == "azurerm_storage_container"

  access := rc.change.after.container_access_type
  access == "blob"   # treat blob as public

  msg := sprintf(
    "Storage container %v allows anonymous public access (container_access_type = %v)",
    [rc.address, access],
  )
}
