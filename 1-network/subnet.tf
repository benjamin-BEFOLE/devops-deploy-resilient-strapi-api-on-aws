# Create public subnets
resource "aws_subnet" "public_subnet1" {
  vpc_id            = aws_vpc.network.id
  cidr_block        = "10.0.1.0/24"
  availability_zone = data.aws_availability_zones.az_available.names[0]

  tags = {
    Name = "public-subnet-1"
  }

  depends_on = [aws_internet_gateway.igw]
}

resource "aws_subnet" "public_subnet2" {
  vpc_id            = aws_vpc.network.id
  cidr_block        = "10.0.2.0/24"
  availability_zone = data.aws_availability_zones.az_available.names[1]

  tags = {
    Name = "public-subnet-2"
  }

  depends_on = [aws_internet_gateway.igw]
}

# Create private subnets
resource "aws_subnet" "private_subnet1" {
  vpc_id            = aws_vpc.network.id
  cidr_block        = "10.0.3.0/24"
  availability_zone = data.aws_availability_zones.az_available.names[0]

  tags = {
    Name = "private-subnet-1"
  }
}

resource "aws_subnet" "private_subnet2" {
  vpc_id            = aws_vpc.network.id
  cidr_block        = "10.0.4.0/24"
  availability_zone = data.aws_availability_zones.az_available.names[1]

  tags = {
    Name = "private-subnet-2"
  }
}
