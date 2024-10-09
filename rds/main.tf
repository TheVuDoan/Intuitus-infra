resource "aws_db_subnet_group" "app_db" {
  name       = "app_db_${var.environment}"
  subnet_ids = var.public_subnet_ids

  tags = {
    Name        = "application-db-subnet-group-${var.environment}"
    Environment = var.environment
  }
}

resource "aws_db_instance" "intuitus_db" {
  identifier           = "intuitus-${var.environment}"
  allocated_storage    = 20
  engine               = "postgres"
  engine_version       = "13"
  instance_class       = "db.t3.micro"
  db_name              = "intuitus_${var.environment}"
  username             = "intuitusadmin"
  password             = random_password.intuitus_db_master_pass.result
  db_subnet_group_name = aws_db_subnet_group.app_db.name
  vpc_security_group_ids = [var.db_security_group_id]
  publicly_accessible  = true
  multi_az             = false
  availability_zone    = "us-east-1a"

  skip_final_snapshot = true

  tags = {
    Name = "intuitus-db-${var.environment}"
  }
}

resource "random_password" "intuitus_db_master_pass" {
  length           = 16
  special          = true
  override_special = "_%@"
}

output "intuitus_db_password" {
  value = aws_db_instance.intuitus_db.password
  sensitive = true
}
