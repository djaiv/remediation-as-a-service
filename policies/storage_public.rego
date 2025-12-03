package terraform.azure.storage

# Fail if any storage container is publicly accessible.

deny contains msg if {
  some rc in input.resource_changes
  rc.type == "azurerm_storage_container"

  after := rc.change.after
  access := after.container_access_type

  access == "blob"  # treat blob as public
  # If you also want to treat "container" as public, you can add:
  # access == "container"

  msg := sprintf(
    "Storage container %v allows anonymous public access (container_access_type = %v)",
    [rc.name, access],
  )
}
