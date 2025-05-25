locals {
  subnet_map_public   = { for k, v in var.subnets : k => v if v.public == true }
  is_there_any_public = length(local.subnet_map_public) > 0
}

resource "aws_internet_gateway" "this" {
  count = local.is_there_any_public ? 1 : 0

  vpc_id = aws_vpc.this.id
  tags = {
    Name = "${var.name}-${var.environment}-igw"
  }
}

resource "aws_vpc" "this" {
  # checkov:skip=CKV2_AWS_11: Ensure VPC flow logging is enabled in all VPCs
  cidr_block           = var.cidr
  enable_dns_support   = true
  enable_dns_hostnames = true
  tags = {
    Name = "${var.name}-${var.environment}"
  }
}

resource "aws_subnet" "these" {
  for_each = var.subnets

  vpc_id            = aws_vpc.this.id
  cidr_block        = each.value.cidr
  availability_zone = each.value.az
  tags = {
    Name = "${each.key}-${var.environment}"
  }
}

resource "aws_route_table" "these" {
  for_each = var.subnets

  vpc_id = aws_subnet.these[each.key].vpc_id
  tags = {
    Name = "${each.key}-${var.environment}-rtable"
  }
}

resource "aws_route" "public" {
  for_each = local.subnet_map_public

  route_table_id         = aws_route_table.these[each.key].id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.this[0].id
}

resource "aws_route_table_association" "these" {
  for_each = var.subnets

  subnet_id      = aws_subnet.these[each.key].id
  route_table_id = aws_route_table.these[each.key].id
}
