output "vpc_arn" {
  value = aws_vpc.this.arn
}

output "vpc_id" {
  value = aws_vpc.this.id
}

output "subnets" {
  value = { for k, v in aws_subnet.these : k => {
    id : v.id,
    arn : v.arn,
    route_table_id : aws_route_table.these[k].id
  } }
}

output "secgroups" {
  value = { for k, v in module.secgroups : k => {
    id : v.id,
    arn : v.arn,
  } }
}

output "vpc_default_route_table_id" {
  value = aws_vpc.this.default_route_table_id
}
