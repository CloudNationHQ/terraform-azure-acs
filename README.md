# Communication Services

This terraform module simplifies the creation and management of azure communication services, providing flexible options for email communication services, domain management, sender usernames, and domain associations, all managed through code.

## Features

Manages a communication service together with its access keys and connection strings.

Optional email communication service with one or more email domains.

Supports both azure managed and customer managed email domains.

Capability to handle multiple sender usernames per email domain.

Automatically associates email domains with the communication service.

Utilization of terratest for robust validation.

<!-- BEGIN_TF_DOCS -->
## Requirements

The following requirements are needed by this module:

- <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) (~> 1.0)

- <a name="requirement_azurerm"></a> [azurerm](#requirement\_azurerm) (~> 4.0)

## Providers

The following providers are used by this module:

- <a name="provider_azurerm"></a> [azurerm](#provider\_azurerm) (~> 4.0)

## Resources

The following resources are used by this module:

- [azurerm_communication_service.this](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/communication_service) (resource)
- [azurerm_communication_service_email_domain_association.this](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/communication_service_email_domain_association) (resource)
- [azurerm_email_communication_service.this](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/email_communication_service) (resource)
- [azurerm_email_communication_service_domain.this](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/email_communication_service_domain) (resource)
- [azurerm_email_communication_service_domain_sender_username.this](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/email_communication_service_domain_sender_username) (resource)

## Required Inputs

The following input variables are required:

### <a name="input_communication"></a> [communication](#input\_communication)

Description: describes communication service related configuration

Type:

```hcl
object({
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
```

## Optional Inputs

The following input variables are optional (have default values):

### <a name="input_resource_group_name"></a> [resource\_group\_name](#input\_resource\_group\_name)

Description: default resource group to be used.

Type: `string`

Default: `null`

### <a name="input_tags"></a> [tags](#input\_tags)

Description: tags to be added to the resources

Type: `map(string)`

Default: `{}`

## Outputs

The following outputs are exported:

### <a name="output_communication"></a> [communication](#output\_communication)

Description: contains the communication service, including connection strings and access keys

### <a name="output_domains"></a> [domains](#output\_domains)

Description: contains all email domains, including dns verification records

### <a name="output_email"></a> [email](#output\_email)

Description: contains the email communication service

### <a name="output_sender_usernames"></a> [sender\_usernames](#output\_sender\_usernames)

Description: contains all email domain sender usernames
<!-- END_TF_DOCS -->

## Goals

For more information, please see our [goals and non-goals](./GOALS.md).

## Testing

For more information, please see our testing [guidelines](./TESTING.md)

## Notes

Using a dedicated module, we've developed a naming convention for resources that's based on specific regular expressions for each type, ensuring correct abbreviations and offering flexibility with multiple prefixes and suffixes.

Full examples detailing all usages, along with integrations with dependency modules, are located in the examples directory.

To update the module's documentation run `make docs`

## Contributors

We welcome contributions from the community! Whether it's reporting a bug, suggesting a new feature, or submitting a pull request, your input is highly valued.

For more information, please see our contribution [guidelines](./CONTRIBUTING.md). <br><br>

<a href="https://github.com/cloudnationhq/terraform-azure-acs/graphs/contributors">
  <img src="https://contrib.rocks/image?repo=cloudnationhq/terraform-azure-acs" />
</a>

## License

MIT Licensed. See [LICENSE](https://github.com/cloudnationhq/terraform-azure-acs/blob/main/LICENSE) for full details.

## References

- [Documentation](https://learn.microsoft.com/en-us/azure/communication-services/)
- [Rest Api](https://learn.microsoft.com/en-us/rest/api/communication/)
- [Rest Api Specs](https://github.com/Azure/azure-rest-api-specs/tree/main/specification/communication)
