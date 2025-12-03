package terraform.azure.storage

# Input is a Terraform plan in JSON format.
# We treat public containers as a policy violation.

deny[msg] {
  rc := input.resource_changes[_]
  rc.type == "azurerm_storage_container"

  access := rc.change.after.container_access_type
  access == "blob"  or "container"    # public read for blobs and containers


  msg := sprintf("Storage container %v allows anonymous public access (container_access_type = %v)", [rc.name, access])
}
