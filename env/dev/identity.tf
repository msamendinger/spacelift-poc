data "azurerm_subscription" "current" {}

resource "azurerm_role_assignment" "spacelift_contributor" {
  scope                = data.azurerm_subscription.current.id
  role_definition_name = "Contributor"
  principal_id         = azurerm_linux_virtual_machine.spacelift-worker.identity[0].principal_id
}
