data "aws_ami" "amazon_linux" {
  most_recent = true

  filter {
    name   = "name"
    values = ["al2023-ami-2023.*-x86_64"]
  }

  owners = ["amazon"]
}

data "aws_subnet" "private_subnet1" {
  filter {
    name   = "tag:Name"
    values = ["private-subnet-1"]
  }
}

data "aws_subnet" "private_subnet2" {
  filter {
    name   = "tag:Name"
    values = ["private-subnet-2"]
  }
}

data "aws_security_group" "server_sg" {
  name = "strapi-server-sg"
}

data "aws_s3_bucket" "strapi_bucket_backend" {
  bucket = var.bucket_strapi_backend
}

data "aws_lb_target_group" "alb_tg" {
  name = "strapi-alb-tg"
}

data "aws_secretsmanager_secret" "api_secrets" {
  name = "strapi/api/secrets"
}

data "aws_secretsmanager_secret" "database_password" {
  name = "strapi/database/password"
}

data "aws_db_instance" "database" {
  db_instance_identifier = "strapi-database"
}
