output "vpc_id" {
  value = aws_vpc.helium_vpc.id
}

output "subnet_ids" {
  value = [aws_subnet.subnet_us_east_1a.id, aws_subnet.subnet_us_east_1b.id, aws_subnet.subnet_us_east_1c.id]
}

output "http_s_sg_id" {
  value = aws_security_group.http_s.id
}

output "http_sg_frontend" {
  value = aws_security_group.http_helium_frontend.id
}

output "http_sg_platform" {
  value = aws_security_group.http_helium_platform.id
}

output "mysql_sg" {
  value = aws_security_group.mysql.id
}

output "elasticache_sg" {
  value = aws_security_group.elasticache.id
}