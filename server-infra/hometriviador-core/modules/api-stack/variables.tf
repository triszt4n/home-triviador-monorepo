variable "environment" {
  type = string
}

variable "vpc_id" {
  type = string
}

variable "alb_subnet_ids" {
  type = list(string)
}

variable "alb_secgroup_ids" {
  type = list(string)
}

variable "alb_internal" {
  type = bool
}

variable "alb_tg_port_mapping" {
  type = number
}

variable "ecs" {
  type = object({
    health_check = optional(object({
      command     = list(string)
      retries     = number
      startPeriod = number
      interval    = number
      timeout     = number
    }))
    family_name        = string
    port_mapping       = number
    task_environment   = map(string)
    memory             = number
    cpu                = number
    desired_task_count = number
    dummy_image_tag    = string
  })
}

variable "db_secgroup_ids" {
  type = list(string)
}

variable "db_subnet_ids" {
  type = list(string)
}

variable "api_secgroup_ids" {
  type = list(string)
}

variable "api_subnet_ids" {
  type = list(string)
}

variable "api_subnet_route_table_ids" {
  type = list(string)
}

variable "db" {
  type = object({
    engine            = optional(string, "postgres")
    engine_version    = optional(string, "16.4")
    instance_class    = optional(string, "db.t3.micro")
    allocated_storage = optional(number, 20)
    port              = optional(number, 5432)
  })
}

variable "db_username" {
  type = string
  sensitive = true
}

variable "db_password" {
  type = string
  sensitive = true
}
