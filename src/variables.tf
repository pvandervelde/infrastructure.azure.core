#
# ANALYTICS
#

variable "sku" {
  description = "Specified the Sku of the Log Analytics Workspace."
  default = "PerGB2018"
}

variable "retention_in_days" {
  description = "The workspace data retention in days. Possible values range between 30 and 730."
  default = 30
}

variable "security_center_subscription" {
  description = "List of subscriptions this log analytics should collect data for. Does not work on free subscription."
  type = list(string)
  default = []
}

variable "solutions" {
  description = "A list of solutions to add to the workspace. Should contain solution_name, publisher and product."
  type = list(object({ solution_name = string, publisher = string, product = string }))
  default = [
      {
        solution_name = "AntiMalware",
        publisher = "Microsoft",
        product = "OMSGallery/AntiMalware",
      },
      {
        solution_name = "AzureActivity",
        publisher = "Microsoft",
        product = "OMSGallery/AzureActivity",
      },
      {
        solution_name = "AzureAppGatewayAnalytics",
        publisher = "Microsoft",
        product = "OMSGallery/AzureAppGatewayAnalytics",
      },
      {
        solution_name = "ContainerInsights",
        publisher = "Microsoft",
        product = "OMSGallery/ContainerInsights",
      },
      {
        solution_name = "KeyVaultAnalytics",
        publisher = "Microsoft",
        product = "OMSGallery/KeyVaultAnalytics",
      },
      {
        solution_name = "NetworkMonitoring",
        publisher = "Microsoft",
        product = "OMSGallery/NetworkMonitoring",
      },
      {
        solution_name = "Security",
        publisher = "Microsoft",
        product = "OMSGallery/Security",
      },
  ]
}

variable "contributors" {
  description = "A list of users / apps that should have Log Analytics Contributer access. Required to use log analytics as log source."
  type = list(string)
  default = []
}

#
# ENVIRONMENT
#

variable "category" {
    default = "analytics"
    description = "The name of the category that all the resources are running in."
}

variable "environment" {
    default = "production"
    description = "The name of the environment that all the resources are running in."
}

variable "environment_short" {
    default = "p"
    description = "The short name of the environment that all the resources are running in."
}

#
# LOCATION
#

variable "location" {
    default = "australiaeast"
    description = "The Azure region in which the resources should be created."
}

variable "location_short" {
    default = "aue"
    description = "The short name of the Azure region in which the resources should be created."
}

#
# TAGS
#

variable "tags" {
  description = "Tags to apply to all resources created."
  type = map(string)
  default = {}
}
