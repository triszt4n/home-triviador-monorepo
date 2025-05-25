variable "environment" {
  type = string
}

variable "domain_name" {
  type = string
}

variable "alb_domain_name" {
  type = string
}

variable "alb_arn" {
  type = string
}

variable "enable_distro" {
  type    = bool
  default = false
}
