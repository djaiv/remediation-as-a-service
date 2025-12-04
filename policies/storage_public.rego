package main

# Fail if any azurerm_storage_container is public.

deny[msg] {
  rc := input.resource_changes[_]
  rc.type == "azurerm_storage_container"

  access := rc.change.after.container_access_type
  access == "blob"   # treat blob as public

  msg := sprintf(
    "Storage container %v allows anonymous public access (container_access_type = %v)",
    [rc.name, access],
  )
}
