
package terraform.azure.storage

deny[msg] {
  resource := input.resource_changes[_]
  resource.type == "azurerm_storage_account"
  allow := resource.change.after.allow_blob_public_access
  allow == true
  msg := sprintf("Storage account %v allows public blob access", [resource.name])
}
