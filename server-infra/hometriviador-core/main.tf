module "vpc" {
  source = "./modules/protected-vpc"

  environment = var.environment
  name        = "api-vpc"
  cidr        = "10.10.10.0/24"
  subnets = {
    "public-1a" = {
      cidr   = "10.10.10.16/28"
      az     = "eu-central-1a"
      public = true
    }
    "public-1b" = {
      cidr   = "10.10.10.32/28"
      az     = "eu-central-1b"
      public = true
    }
    "private-1a" = {
      cidr = "10.10.10.48/28"
      az   = "eu-central-1a"
    }
    "private-1b" = {
      cidr = "10.10.10.64/28"
      az   = "eu-central-1b"
    }
    "alb-1a" = {
      cidr = "10.10.10.112/28"
      az   = "eu-central-1a"
    }
    "alb-1b" = {
      cidr = "10.10.10.128/28"
      az   = "eu-central-1b"
    }
  }
  secgroups = {
    "alb-sg" = {
      "in-80" = {
        type      = "ingress"
        cidr      = "10.10.10.0/24"
        from_port = 80
        to_port   = 80
        protocol  = "tcp"
      }
      "out" = {
        type     = "egress"
        cidr     = "0.0.0.0/0"
        protocol = "-1"
      }
      "cloudfront" = {
        type      = "cloudfront"
        from_port = 80
        to_port   = 80
        protocol  = "tcp"
      }
    }
    "private-sg" = {
      "in" = {
        type     = "ingress"
        cidr     = "10.10.10.0/24"
        protocol = "-1"
      }
      "out" = {
        type     = "egress"
        cidr     = "0.0.0.0/0"
        protocol = "-1"
      }
    }
    "db-sg" = {
      "in" = {
        type      = "ingress"
        cidr      = "10.10.10.0/24"
        protocol  = "tcp"
        from_port = 5432
        to_port   = 5432
      }
      "out" = {
        type     = "egress"
        cidr     = "10.10.10.0/24"
        protocol = "-1"
      }
    }
    "api-sg" = {
      "in" = {
        type     = "ingress"
        cidr     = "10.10.10.0/24"
        protocol = "-1"
      }
      "in-sch" = {
        type     = "ingress"
        cidr     = "152.66.0.0/16"
        protocol = "-1"
      }
      "out" = {
        type     = "egress"
        cidr     = "0.0.0.0/0"
        protocol = "-1"
      }
    }
  }
}

data "aws_ssm_parameter" "db_username" {
  name            = "/hometriviador-dev/db-username"
  with_decryption = true
}

data "aws_ssm_parameter" "db_password" {
  name            = "/hometriviador-dev/db-password"
  with_decryption = true
}

module "api" {
  source = "./modules/api-stack"

  environment = var.environment
  vpc_id      = module.vpc.vpc_id

  alb_tg_port_mapping = 80
  alb_secgroup_ids    = [module.vpc.secgroups["alb-sg"].id]
  alb_subnet_ids      = [module.vpc.subnets["alb-1a"].id, module.vpc.subnets["alb-1b"].id]
  alb_internal        = true # does not need to be internet-facing

  db_secgroup_ids = [module.vpc.secgroups["db-sg"].id]
  db_subnet_ids   = [module.vpc.subnets["private-1a"].id, module.vpc.subnets["private-1b"].id]

  api_secgroup_ids           = [module.vpc.secgroups["api-sg"].id]
  api_subnet_ids             = [module.vpc.subnets["public-1a"].id, module.vpc.subnets["public-1b"].id]
  api_subnet_route_table_ids = [for s in values(module.vpc.subnets) : s.route_table_id]

  ecs = {
    dummy_image_tag = "dummy-image-tag:5"
    family_name     = "api"
    port_mapping    = 80
    task_environment = {
      PORT                   = "80"
      POSTGRES_DB            = "hometriviador"
      POSTGRES_USER          = data.aws_ssm_parameter.db_username.value
      POSTGRES_PASSWORD      = data.aws_ssm_parameter.db_password.value
    }
    memory             = 512
    cpu                = 256
    desired_task_count = var.enable_ecs ? 1 : 0
  }

  db = {
    engine         = "postgres"
    engine_version = "16.4"
    instance_class = "db.t3.micro"
  }
  db_username = data.aws_ssm_parameter.db_username.value
  db_password = data.aws_ssm_parameter.db_password.value
}

module "frontend" {
  source = "./modules/cloudfront-s3-origin"

  environment     = var.environment
  domain_name     = var.domain_name
  alb_domain_name = module.api.alb_dns_name
  alb_arn         = module.api.alb_arn
  enable_distro   = var.enable_distro

  providers = {
    aws = aws.global
  }
}
