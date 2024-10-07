resource "aws_db_subnet_group" "helium" {
  name       = "helium"
  subnet_ids = [for id in var.subnet_ids : id]
}

resource "aws_db_instance" "helium" {
  identifier                 = "helium_${var.environment}"
  allocated_storage          = 20
  db_name                    = "platform_${var.environment}"
  engine                     = "mysql"
  engine_version             = "8.0"
  instance_class             = "db.t3.micro"
  username                   = var.username
  password                   = var.password
  skip_final_snapshot        = true
  auto_minor_version_upgrade = true
  deletion_protection        = true
  backup_retention_period    = 7
  vpc_security_group_ids = [var.mysql_sg]
  db_subnet_group_name       = aws_db_subnet_group.helium.name
}

output "db_host" {
  value = aws_db_instance.helium.endpoint
}