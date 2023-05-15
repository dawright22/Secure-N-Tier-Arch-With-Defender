variable "resource_group_location" {
  description = "Location of the resource group."
}

variable "resource_group_name" {
  description = "Name of the resource group name that's combined with a random ID so name is unique in your Azure subscription."
}

variable "name" {
  description = "Name of the resources"
}

variable "VNet" {
  description = "The ID of the Vnet."
  
}

variable "hvn_id" {
  description = "The ID of the HCP HVN."
  type        = string
  default     = "azure-hcp-vault-hvn"
}

variable "cluster_id" {
  description = "The ID of the HCP Vault cluster."
  type        = string
  default     = "azure-hcp-vault-cluster"
}

variable "peering_id" {
  description = "The ID of the HCP peering connection."
  type        = string
  default     = "azure-peering"
}

variable "route_id" {
  description = "The ID of the HCP HVN route."
  type        = string
  default     = "azure-hvn-route"
}

variable "hcp_region" {
  description = "The region of the HCP HVN and Vault cluster."
  type        = string
 
}

variable "cloud_provider" {
  description = "The cloud provider of the HCP HVN and Vault cluster."
  type        = string
  default     = "azure"
}

variable "tier" {
  description = "Tier of the HCP Vault cluster. Valid options for tiers."
  type        = string
  default     = "dev"
}