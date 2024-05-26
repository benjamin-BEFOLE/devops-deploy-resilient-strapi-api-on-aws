resource "aws_launch_template" "lt" {
  name          = "strapi-server-lt"
  image_id      = data.aws_ami.amazon_linux.id
  instance_type = "t3.small"
  user_data     = base64encode(data.template_file.user_data.rendered)

  vpc_security_group_ids = [data.aws_security_group.server_sg.id]

  iam_instance_profile {
    arn = aws_iam_instance_profile.profile.arn
  }

  monitoring {
    enabled = true
  }
}

data "template_file" "user_data" {
  template = file("./scripts/user-data.sh.tpl")

  vars = {
    bucket_strapi_backend = var.bucket_strapi_backend
    api_secrets_id        = data.aws_secretsmanager_secret.api_secrets.id
    database_password_id  = data.aws_secretsmanager_secret.database_password.id
    database_client       = data.aws_db_instance.database.engine
    database_port         = data.aws_db_instance.database.port
    database_name         = var.database_name
    database_username     = var.database_username
    database_host         = data.aws_db_instance.database.address
    strapi_start_sh       = data.template_file.strapi_start_sh.rendered
    strapi_service        = data.template_file.strapi_service.rendered
  }
}

data "template_file" "strapi_start_sh" {
  template = file("./scripts/strapi-start.sh")
}

data "template_file" "strapi_service" {
  template = file("./services/strapi.service")
}
