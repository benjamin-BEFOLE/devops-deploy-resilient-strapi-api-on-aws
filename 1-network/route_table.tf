# Create public route table
resource "aws_route_table" "public_route_table" {
  vpc_id = aws_vpc.network.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }
}

## Associate public route table to public subnets
resource "aws_route_table_association" "public_route_table_with_public_subnet1" {
  route_table_id = aws_route_table.public_route_table.id
  subnet_id      = aws_subnet.public_subnet1.id
}

resource "aws_route_table_association" "public_route_table_with_public_subnet2" {
  route_table_id = aws_route_table.public_route_table.id
  subnet_id      = aws_subnet.public_subnet2.id
}

# Create private route table
resource "aws_route_table" "private_route_table" {
  vpc_id = aws_vpc.network.id

  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.ngw.id
  }
}

## Associate private route table to private subnets
resource "aws_route_table_association" "private_route_table_with_private_subnet1" {
  route_table_id = aws_route_table.private_route_table.id
  subnet_id      = aws_subnet.private_subnet1.id
}

resource "aws_route_table_association" "private_route_table_with_private_subnet2" {
  route_table_id = aws_route_table.private_route_table.id
  subnet_id      = aws_subnet.private_subnet2.id
}

## Associate private route table to s3 vpc endpoint 
resource "aws_vpc_endpoint_route_table_association" "private_route_table_with_vpc_endpoint_s3" {
  route_table_id  = aws_route_table.private_route_table.id
  vpc_endpoint_id = aws_vpc_endpoint.vpce_s3.id
}
