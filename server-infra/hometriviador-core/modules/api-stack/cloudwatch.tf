resource "aws_cloudwatch_log_group" "this" {
  name              = "hometriviador-${var.environment}/ecs/api-logs"
  retention_in_days = 7
}
