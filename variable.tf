variable "instance_name" {
  description = "Intance Name"
  type        = string
}

variable "my_ip" {
  description = "my_ip"
  type        = string
}

variable "db_user" {
  description = "Database User"
  type        = string
}

variable "db_password" {
  description = "Database Password"
  type        = string
  sensitive   = true
}

variable "db_name" {
  description = "Database Name"
  type        = string
}

variable "region" {
  description = "Region"
  type        = string
}

variable "ami_id" {
  description = "Ami Id"
  type        = string
}
