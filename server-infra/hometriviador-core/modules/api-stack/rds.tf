resource "aws_db_subnet_group" "this" {
  name       = "rds-subnet-group-${var.environment}"
  subnet_ids = var.db_subnet_ids
}

resource "aws_db_instance" "this" {
  identifier = "rds-db-${var.environment}"

  allocated_storage = var.db.allocated_storage
  engine            = var.db.engine
  engine_version    = var.db.engine_version
  instance_class    = var.db.instance_class

  db_name  = "hometriviador"
  username = var.db_username
  password = var.db_password
  port     = var.db.port

  vpc_security_group_ids = var.db_secgroup_ids
  db_subnet_group_name   = aws_db_subnet_group.this.name

  skip_final_snapshot = true
}
