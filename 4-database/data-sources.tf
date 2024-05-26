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

data "aws_security_group" "database_sg" {
  name = "strapi-database-sg"
}

data "aws_secretsmanager_secret" "database_password" {
  name = "strapi/database/password"
}

data "aws_secretsmanager_secret_version" "database_password" {
  secret_id = data.aws_secretsmanager_secret.database_password.id
}
