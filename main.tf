# communication service
resource "azurerm_communication_service" "this" {
  resource_group_name = coalesce(
    var.communication.resource_group_name, var.resource_group_name
  )

  data_location = var.communication.data_location

  tags = coalesce(
    var.communication.tags, var.tags
  )

  name = var.communication.name
}

# email communication service
resource "azurerm_email_communication_service" "this" {
  for_each = var.communication.email != null ? var.communication.email : {}

  name = coalesce(
    each.value.name, each.key
  )

  resource_group_name = coalesce(
    each.value.resource_group_name, var.communication.resource_group_name, var.resource_group_name
  )

  data_location = var.communication.data_location

  tags = coalesce(
    each.value.tags, var.tags
  )
}

# email domains
resource "azurerm_email_communication_service_domain" "this" {
  for_each = merge([
    for ekey, email in coalesce(var.communication.email, {}) : {
      for dkey, domain in coalesce(email.domains, {}) :
      "${ekey}.${dkey}" => {
        email_key                        = ekey
        domain_key                       = dkey
        name                             = domain.name
        domain_management                = domain.domain_management
        user_engagement_tracking_enabled = domain.user_engagement_tracking_enabled
        associate                        = domain.associate
        tags                             = domain.tags
      }
    }
  ]...)

  name = coalesce(
    each.value.name, each.value.domain_key
  )

  tags = coalesce(
    each.value.tags, var.tags
  )

  email_service_id                 = azurerm_email_communication_service.this[each.value.email_key].id
  domain_management                = each.value.domain_management
  user_engagement_tracking_enabled = each.value.user_engagement_tracking_enabled
}

# domain sender usernames
resource "azurerm_email_communication_service_domain_sender_username" "this" {
  for_each = merge([
    for ekey, email in coalesce(var.communication.email, {}) : merge([
      for dkey, domain in coalesce(email.domains, {}) : {
        for ukey, user in coalesce(domain.sender_usernames, {}) :
        "${ekey}.${dkey}.${ukey}" => {
          email_key    = ekey
          domain_key   = dkey
          username_key = ukey
          name         = user.name
          display_name = user.display_name
        }
      }
    ]...)
  ]...)

  name = coalesce(
    each.value.name, each.value.username_key
  )

  email_service_domain_id = azurerm_email_communication_service_domain.this["${each.value.email_key}.${each.value.domain_key}"].id
  display_name            = each.value.display_name

}

# email domain associations
resource "azurerm_communication_service_email_domain_association" "this" {
  for_each = {
    for key, domain in merge([
      for ekey, email in coalesce(var.communication.email, {}) : {
        for dkey, dom in coalesce(email.domains, {}) :
        "${ekey}.${dkey}" => {
          email_key  = ekey
          domain_key = dkey
          associate  = dom.associate
        }
      }
    ]...) : key => domain
    if coalesce(domain.associate, true)
  }

  communication_service_id = azurerm_communication_service.this.id
  email_service_domain_id  = azurerm_email_communication_service_domain.this[each.key].id
}
