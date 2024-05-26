data "aws_vpc" "vpc" {
  filter {
    name   = "tag:Name"
    values = ["strapi-vpc"]
  }
}

data "aws_subnet" "public_subnet1" {
  filter {
    name   = "tag:Name"
    values = ["public-subnet-1"]
  }
}

data "aws_subnet" "public_subnet2" {
  filter {
    name   = "tag:Name"
    values = ["public-subnet-2"]
  }
}

data "aws_security_group" "alb_sg" {
  name = "strapi-alb-sg"
}
