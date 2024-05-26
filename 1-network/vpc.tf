resource "aws_vpc" "network" {
  cidr_block = "10.0.0.0/16"

  tags = {
    Name = "strapi-vpc"
  }
}

resource "aws_vpc_endpoint" "vpce_s3" {
  vpc_id       = aws_vpc.network.id
  service_name = "com.amazonaws.us-east-1.s3"
}
