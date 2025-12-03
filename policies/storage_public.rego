package terraform.azure.storage

# Flag any azurerm_storage_container that allows anonymous public access.

deny contains msg if {
  some res in input.planned_values.root_module.resources
  res.type == "azurerm_storage_container"

  access := res.values.container_access_type

  access == "blob"  # public blob access
  # If you also want "container" treated as public:
  # access == "container"

  msg := sprintf(
    "Storage container %v allows anonymous public access (container_access_type = %v)",
    [res.name, access],
  )
}
