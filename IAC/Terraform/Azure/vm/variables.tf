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

variable "vnet_address_space" {
  type        = list(string)
  default     = ["10.0.0.0/22"]
  description = "Address space for virtual network"
}

variable "snet_address_space" {
  type        = list(string)
  default     = ["10.0.1.0/24"]
  description = "Address space for subnet"
}

variable "os_info" {
  type        = list(object({
    publisher = string
    offer = string
    sku = string
    version = string
  }))
  default     = [
    {
      publisher = "OpenLogic"
      offer     = "CentOS"
      sku       = "7.5"
      version   = "latest"
    }
  ]
  description = "OS image details"
}

variable "username" {
  type        = string
  description = "The username for the local account that will be created on the new VM."
  default     = "azureadmin"
}