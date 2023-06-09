data "azurerm_subscription" "current" {}

resource "azurerm_subscription_policy_assignment" "asb_assignment" {
  name                 = "${var.name}-azuresecuritybenchmark"
  display_name         = "Azure Security N-tier Benchmark"
  policy_definition_id = "/providers/Microsoft.Authorization/policySetDefinitions/1f3afdf9-d0c9-4c3d-847f-89da613e70a8"
  subscription_id      = data.azurerm_subscription.current.id
}

resource "azurerm_security_center_subscription_pricing" "mdc_arm" {
  tier          = "Standard"
  resource_type = "Arm"
}

resource "azurerm_security_center_subscription_pricing" "mdc_servers" {
  tier          = "Standard"
  resource_type = "VirtualMachines"
}

# resource "azurerm_security_center_setting" "setting_mcas" {
#   setting_name = "MCAS"
#   enabled      = false
# }

# resource "azurerm_security_center_setting" "setting_mde" {
#   setting_name = "WDATP"
#   enabled      = true
# }

resource "azurerm_security_center_contact" "mdc_contact" {
  email = var.email
  phone = var.phone

  alert_notifications = true
  alerts_to_admins    = true
}

resource "azurerm_security_center_auto_provisioning" "auto-provisioning" {
  auto_provision = "On"
}

resource "azurerm_log_analytics_workspace" "la_workspace" { 
  name = "${var.name}-security-workspace" 
  resource_group_name             = var.resource_group_name
  location                        = var.resource_group_location 
  sku = "PerGB2018" 
}

resource "azurerm_security_center_workspace" "la_workspace" {
  scope        = data.azurerm_subscription.current.id
  workspace_id = azurerm_log_analytics_workspace.la_workspace.id
}

resource "azurerm_subscription_policy_assignment" "va-auto-provisioning" {
  name                 = "${var.name}-va-autoprovisioning"
  display_name         = "Configure machines to receive a vulnerability assessment provider"
  policy_definition_id = "/providers/Microsoft.Authorization/policyDefinitions/13ce0167-8ca6-4048-8e6b-f996402e3c1b"
  subscription_id      = data.azurerm_subscription.current.id
  identity {
    type = "SystemAssigned"
  }
  location = var.resource_group_location
  parameters = <<PARAMS
{ "vaType": { "value": "mdeTvm" } }
PARAMS
}

resource "azurerm_role_assignment" "va-auto-provisioning-identity-role" {
  scope              = data.azurerm_subscription.current.id
  role_definition_id = "/providers/Microsoft.Authorization/roleDefinitions/fb1c8493-542b-48eb-b624-b4c8fea62acd"
  principal_id       = azurerm_subscription_policy_assignment.va-auto-provisioning.identity[0].principal_id
}

resource "azurerm_log_analytics_solution" "la_workspace_security" {
  solution_name         = "Security"
  resource_group_name             = var.resource_group_name
  location                        = var.resource_group_location
  workspace_resource_id = azurerm_log_analytics_workspace.la_workspace.id
  workspace_name        = azurerm_log_analytics_workspace.la_workspace.name

  plan {
    publisher = "Microsoft"
    product   = "OMSGallery/Security"
  }
}

resource "azurerm_log_analytics_solution" "la_workspace_securityfree" {
  solution_name         = "SecurityCenterFree"
  resource_group_name             = var.resource_group_name
  location                        = var.resource_group_location
  workspace_resource_id = azurerm_log_analytics_workspace.la_workspace.id
  workspace_name        = azurerm_log_analytics_workspace.la_workspace.name

  plan {
    publisher = "Microsoft"
    product   = "OMSGallery/SecurityCenterFree"
  }
}

resource "azurerm_security_center_automation" "la-exports" {
  name                = "${var.name}-ExportToWorkspace"
  resource_group_name             = var.resource_group_name
  location                        = var.resource_group_location

  action {
    type              = "loganalytics"
    resource_id       = azurerm_log_analytics_workspace.la_workspace.id
  }

  source {
    event_source = "Alerts"
    rule_set {
      rule {
        property_path  = "Severity"
        operator       = "Equals"
        expected_value = "High"
        property_type  = "String"
      }
      rule {
        property_path  = "Severity"
        operator       = "Equals"
        expected_value = "Medium"
        property_type  = "String"
      }
    }
  }

  source {
    event_source = "SecureScores"
  }

  source {
    event_source = "SecureScoreControls"
  }

  scopes = [ data.azurerm_subscription.current.id ]
}