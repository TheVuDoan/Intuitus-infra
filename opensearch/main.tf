data "aws_caller_identity" "current" {}

resource "aws_opensearch_domain" "intuitus_opensearch" {
  domain_name     = "intuitus-opensearch"
  engine_version  = "OpenSearch_1.0"
  
  cluster_config {
    instance_type          = "t3.small.search"
    instance_count         = 1
    zone_awareness_enabled = false
  }

  ebs_options {
    ebs_enabled = true
    volume_size = 10
    volume_type = "gp2"
  }

  node_to_node_encryption {
    enabled = true
  }

  encrypt_at_rest {
    enabled = true
  }

  access_policies = jsonencode({
    "Version": "2012-10-17",
    "Statement": [
      {
        "Effect": "Allow",
        "Principal": {
          "AWS": "*"
        },
        "Action": "es:*",
        "Resource": "arn:aws:es:${var.aws_region}:${data.aws_caller_identity.current.account_id}:domain/intuitus-opensearch/*"
      }
    ]
  })

  advanced_security_options {
    enabled                        = true
    internal_user_database_enabled = true
    master_user_options {
      master_user_name     = "intuitusadmin"
      master_user_password = random_password.intuitus_os_master_pass.result
    }
  }

  domain_endpoint_options {
    enforce_https = true
  }

  advanced_options = {
    "rest.action.multi.allow_explicit_index" = "true"
  }

  # For demo purposes, we are not putting opensearch in a VPC
  # vpc_options {
    # subnet_ids = [var.public_subnet_ids[0]]
    # security_group_ids = [var.os_security_group_id]
  # }

  tags = {
    Name = "intuitus-opensearch"
    Environment = var.environment
  }
}

resource "random_password" "intuitus_os_master_pass" {
  length           = 16
  special          = true
  override_special = "_%@"
}

output "intuitus_os_password" {
  value     = random_password.intuitus_os_master_pass.result
  sensitive = true
}
