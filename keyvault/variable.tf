variable "subscription_id" {
  type        = string
  description = "Azure subscription id"
}
variable "environment" {
  type        = string
  description = "environment"
}
variable "resource_group_name" {
  type        = string
  description = "Resource group name"
}
variable "resource_group_location" {
  type        = string
  description = "value of location"
}
variable "keyvault_name_prefix" {
  type        = string
  description = "Key vault name prefix"
}
