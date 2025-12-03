package terraform.azure.storage

# Flags any storage container that allows anonymous public access.
# New style Rego: deny contains msg if { ... }

deny contains msg if {
  some rc in input.resource_changes
  rc.type == "azurerm_storage_container"

  access := rc.change.after.container_access_type
  access == "blob"   # public blob access
  # Uncomment this if you also want to treat "container" as public:
  # access == "container"

  msg := sprintf(
    "Storage container %v allows anonymous public access (container_access_type = %v)",
    [rc.name, access],
  )
}
