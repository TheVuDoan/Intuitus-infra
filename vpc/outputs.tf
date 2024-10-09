output "public_subnet_ids" {
  value = aws_subnet.public_subnets.*.id
}

output "db_security_group_id" {
  value = aws_security_group.intuitus_db.id
}

output "os_security_group_id" {
  value = aws_security_group.intuitus_opensearch.id
}
