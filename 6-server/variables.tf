variable "aws_region" {
  type = string
}

variable "bucket_strapi_backend" {
  type = string
}

variable "database_name" {
  type    = string
  default = "strapi"
}

variable "database_username" {
  type    = string
  default = "app"
}
