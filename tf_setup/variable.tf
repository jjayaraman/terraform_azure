variable "environment" {
  type        = string
  description = "environment"
}
variable "subscription_id" {
  type        = string
  description = "Azure subscription id"
}
variable "resource_group_name" {
  type        = string
  description = "Resource group name"
}
variable "resource_group_location" {
  type        = string
  description = "value of location"
}
variable "storage_name_prefix" {
  type        = string
  description = "Terraform state Storage name prefix"
}
