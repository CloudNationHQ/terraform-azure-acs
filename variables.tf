variable "communication" {
  description = "describes communication service related configuration"
  type = object({
    name                = string
    resource_group_name = optional(string)
    data_location       = optional(string)
    tags                = optional(map(string))
    email = optional(map(object({
      name                = optional(string)
      resource_group_name = optional(string)
      data_location       = optional(string)
      tags                = optional(map(string))
      domains = optional(map(object({
        name                             = optional(string)
        domain_management                = string
        user_engagement_tracking_enabled = optional(bool)
        associate                        = optional(bool)
        tags                             = optional(map(string))
        sender_usernames = optional(map(object({
          name         = optional(string)
          display_name = optional(string)
        })))
      })))
    })))
  })

  validation {
    condition     = lookup(var.communication, "resource_group_name", null) != null || var.resource_group_name != null
    error_message = "resource_group_name must be set on var.communication.resource_group_name or on the module-level var.resource_group_name."
  }

  validation {
    condition = alltrue([
      for d in values(merge([
        for _, email in coalesce(var.communication.email, {}) :
        coalesce(email.domains, {})
      ]...)) :
      contains(["AzureManaged", "CustomerManaged", "CustomerManagedInExchangeOnline"], d.domain_management)
    ])
    error_message = "domain_management must be one of: AzureManaged, CustomerManaged, CustomerManagedInExchangeOnline."
  }
}

variable "resource_group_name" {
  description = "default resource group to be used."
  type        = string
  default     = null
}

variable "tags" {
  description = "tags to be added to the resources"
  type        = map(string)
  default     = {}
}
