module "secgroups" {
  for_each = var.secgroups
  source   = "../secgroup"

  environment = var.environment
  name        = each.key
  vpc_id      = aws_vpc.this.id
  rules       = each.value
}
