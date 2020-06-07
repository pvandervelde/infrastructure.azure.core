terraform {
    backend "remote" {
        organization = "calvinverse"

        workspaces {
            name = "infrastructure-azure-core"
        }
    }
}

provider "azurerm" {
    version = "~>2.7.0"
    features {}
}

#
# LOCALS
#

locals {
    name_prefix = "${var.environment_short}-${var.location_short}"
    name_prefix_tf = "${local.name_prefix}-tf-${var.category}"
}

#
# RESOURCE GROUP
#

resource "azurerm_resource_group" "logs" {
  location = var.location
  name = "${local.name_prefix_tf}-rg"
  tags = var.tags
}

#
# ANALYTICS
#

resource "azurerm_role_assignment" "logs" {
  count = length(var.contributors)
  principal_id = var.contributors[count.index]
  role_definition_name = "Log Analytics Contributor"
  scope = azurerm_resource_group.logs.id
}

resource "azurerm_log_analytics_workspace" "logs" {
  location = azurerm_resource_group.logs.location
  name = "${local.name_prefix_tf}-law-logs"
  resource_group_name = azurerm_resource_group.logs.name
  retention_in_days = var.retention_in_days
  sku = var.sku

  tags = var.tags
}

resource "azurerm_security_center_workspace" "logs" {
  count = length(var.security_center_subscription)
  scope = "/subscriptions/${element(var.security_center_subscription, count.index)}"
  workspace_id = azurerm_log_analytics_workspace.logs.id
}

resource "azurerm_log_analytics_solution" "logs" {
  count = length(var.solutions)
  location = azurerm_resource_group.logs.location
  resource_group_name = azurerm_resource_group.logs.name
  solution_name = var.solutions[count.index].solution_name
  workspace_name = azurerm_log_analytics_workspace.logs.name
  workspace_resource_id = azurerm_log_analytics_workspace.logs.id

  plan {
    publisher = var.solutions[count.index].publisher
    product = var.solutions[count.index].product
  }
}
