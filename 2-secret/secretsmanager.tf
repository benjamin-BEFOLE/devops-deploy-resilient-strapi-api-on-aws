resource "aws_secretsmanager_secret" "api_secrets" {
  name        = "strapi/api/secrets"
  description = "Contains strapi API secrets"
}

resource "aws_secretsmanager_secret" "database_password" {
  name = "strapi/database/password"
}
