variable "location" {
  type        = string
  default     = "westeurope"
  description = "Location of the resource group."
}

variable "env" {
  type        = string
  default     = "dev"
  description = "The name of the environment."
}

variable "name_prefix" {
  type        = string
  default     = "vk"
  description = "Prefix for creation of resources."
}

variable "node_count" {
  type        = number
  description = "The initial quantity of nodes for the node pool."
  default     = 2
}

variable "msi_id" {
  type        = string
  description = "The Managed Service Identity ID. Set this value if you're running this example using Managed Identity as the authentication method."
  default     = null
}

variable "username" {
  type        = string
  description = "The admin username for the new cluster."
  default     = "azureadmin"
}