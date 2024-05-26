resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.network.id

  tags = {
    Name = "strapi-igw"
  }
}
