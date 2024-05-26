resource "aws_eip" "ngw_eip" {
  domain = "vpc"

  depends_on = [aws_internet_gateway.igw]
}

resource "aws_nat_gateway" "ngw" {
  allocation_id = aws_eip.ngw_eip.id
  subnet_id     = aws_subnet.public_subnet1.id

  tags = {
    Name = "strapi-nat-gw"
  }
}
