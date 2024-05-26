resource "aws_db_instance" "db" {
  identifier           = "strapi-database"
  allocated_storage    = 10
  db_name              = "strapi"
  engine               = "postgres"
  engine_version       = "14.12"
  port                 = 5432
  parameter_group_name = "default.postgres14"
  instance_class       = "db.t3.micro"
  username             = "app"
  password             = data.aws_secretsmanager_secret_version.database_password.secret_string
  apply_immediately    = true
  multi_az             = true

  db_subnet_group_name   = aws_db_subnet_group.subnet_group.name
  vpc_security_group_ids = [data.aws_security_group.database_sg.id]
}
