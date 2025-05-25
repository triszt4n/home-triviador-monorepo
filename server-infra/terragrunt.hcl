locals {
  environment            = "dev"
  account_name           = "hometriviador"
  account_id             = "185226996869"
  feature                = "hometriviador-core"
  s3_backend_bucket_name = "hometriviador-aws-terraform-state"
  s3_backend_region      = "eu-central-1"
  provider_main_region   = "eu-central-1"
}

terraform {
  source = "./hometriviador-core"
}

generate "provider" {
  path      = "provider.tf"
  if_exists = "overwrite_terragrunt"
  contents  = <<-EOF
provider "aws" {
  region = "${local.provider_main_region}"
  default_tags {
    tags = {
      environment  = "${local.environment}"
      account_name = "${local.account_name}"
      account_id   = "${local.account_id}"
      feature      = "${local.feature}"
    }
  }
}
provider "aws" {
  alias  = "global"
  region = "us-east-1"
  default_tags {
    tags = {
      environment  = "${local.environment}"
      account_name = "${local.account_name}"
      account_id   = "${local.account_id}"
      feature      = "${local.feature}"
    }
  }
}
EOF
}

generate "backend" {
  path      = "backend.tf"
  if_exists = "overwrite_terragrunt"
  contents  = <<-EOF
terraform {
  backend "s3" {
    bucket  = "${local.s3_backend_bucket_name}"
    encrypt = true
    key     = "terraform.tfstate"
    region  = "${local.s3_backend_region}"
  }
}
EOF
}

inputs = {
  environment    = local.environment
  region         = local.provider_main_region
  domain_name    = "hometriviador.trisz.hu"
  enable_ecs     = true
  enable_distro  = true
}
