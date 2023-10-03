variable "location" {
  type        = string
  default     = "westeurope"
  description = "Location of the resource group."
}

variable "name_prefix" {
  type        = string
  default     = "vk"
  description = "Prefix for creation of resources."
}
variable "target_env_scope" {
  type        = string
  default     = "nonprod"
  description = "Scope of target environment: prod or nonprod"
}
