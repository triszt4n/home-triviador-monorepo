variable "environment" {
  type = string
}

variable "name" {
  type = string
}

variable "vpc_id" {
  type = string
}

variable "rules" {
  type = map(object({
    type      = string
    cidr      = optional(string)
    from_port = optional(number)
    to_port   = optional(number)
    protocol  = optional(string)
  }))
}
