module "naming" {
  source  = "cloudnationhq/naming/azure"
  version = "~> 0.25"

  suffix = ["demo", "dev"]
}

module "rg" {
  source  = "cloudnationhq/rg/azure"
  version = "~> 2.0"

  groups = {
    demo = {
      name     = module.naming.resource_group.name_unique
      location = "westeurope"
    }
  }
}

module "acs" {
  source  = "cloudnationhq/acs/azure"
  version = "~> 1.0"

  communication = {
    name                = module.naming.communication_service.name_unique
    resource_group_name = module.rg.groups.demo.name
    data_location       = "Europe"

    email = {
      main = {
        name          = "${module.naming.communication_service.name_unique}-email"
        data_location = "Europe"

        domains = {
          managed = {
            name              = "AzureManagedDomain"
            domain_management = "AzureManaged"

            sender_usernames = {
              alerts = {
                display_name = "Alerts"
              }
              support = {
                display_name = "Support"
              }
            }
          }

          custom = {
            name                             = "mail.example.com"
            domain_management                = "CustomerManaged"
            user_engagement_tracking_enabled = true
            associate                        = false
          }
        }
      }
    }
  }

  tags = {
    environment = "demo"
  }
}
