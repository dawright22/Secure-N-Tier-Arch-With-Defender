##############################################################################
# Variables File
# 
# Here is where we store the default values for all the variables used in our
# Terraform code. If you create a variable with no default, the user will be
# prompted to enter it (or define it via config file or command line flags.)

variable "resource_group_location" {
  default     = "AustraliaCentral"
  description = "Location of the resource group."
}

variable "resource_group_name_prefix" {
  default     = "tf"
  description = "Prefix of the resource group name that's combined with a random ID so name is unique in your Azure subscription."
}

variable "app_gtw_sub" {
  description = "Name of the app gateway subnet"
  default     = ""
}

variable "app_gtw_ip" {
  description = "Name of the app gateway ip"
  default     = ""
}

variable "scale_set_sub" {
  description = "Name of the scale set subnet"
  default     = ""
}

variable "lb_sub" {
  default     = ""
  description = "Name of the Lb subnet"
}

variable "bastion_public_ip" {
  default     = ""
  description = "bastion public ip"
}

variable "bastion_subnet_id" {
  default     = ""
  description = "bastion subnet id"
}

variable "admin_user" {
  description = "User name to use as the admin account on the VMs that will be part of the VM scale set"
  default     = "azureuser"
}

variable "admin_password" {
  description = "Default password for admin account"
  default     = ""
}

variable "throughput" {
  type    = number
  default = 400
}

variable "email" {
  description = "Email address to send alerts to"
  default = "hello@hashicorp.com"
}

variable "phone" {
    description = "Phone number to send alerts to"
    default = "555-555-5555"
}

variable "client_id" {
  description = "The ID of the HCP Vault cluster client."
  type        = string
  default     = "Y9cDGhRE0tZLn2b2cetjrWym04xfOJs1"
}

variable "client_secret" {
    type = string
    description = "The Key of the HCP Vault cluster client."
    default = "CXPpNC3cg-nwoeZH5C5xnyT_1O-NFRjyCOHC2hynVlsOrQreEX-LyPHzbBn9urEX"
}

variable "hcp_region" {
  description = "The region of the HCP HVN and Vault cluster."
  type        = string
  default     = "westus2"
}
