output "communication" {
  description = "contains the communication service, including connection strings and access keys"
  value       = azurerm_communication_service.this
  sensitive   = true
}

output "email" {
  description = "contains the email communication service"
  value       = azurerm_email_communication_service.this
}

output "domains" {
  description = "contains all email domains, including dns verification records"
  value       = azurerm_email_communication_service_domain.this
}

output "sender_usernames" {
  description = "contains all email domain sender usernames"
  value       = azurerm_email_communication_service_domain_sender_username.this
}
