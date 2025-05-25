variable "environment" {
  type = string
}

variable "name" {
  description = "Name of the VPC to create"
  type        = string
}

variable "cidr" {
  description = "CIDR range of the VPC"
  type        = string
}

variable "subnets" {
  description = "Subnets to create in the VPC"
  type = map(object({
    cidr   = string
    az     = string
    public = optional(bool, false)
  }))
}

variable "secgroups" {
  description = "Security groups to create in the VPC"
  type = map(map(object({
    type      = string
    cidr      = optional(string)
    from_port = optional(number)
    to_port   = optional(number)
    protocol  = optional(string)
  })))
}
