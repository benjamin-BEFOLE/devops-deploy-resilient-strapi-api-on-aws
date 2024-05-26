resource "aws_db_subnet_group" "subnet_group" {
  name       = "strapi-db-subnet-group"
  subnet_ids = [data.aws_subnet.private_subnet1.id, data.aws_subnet.private_subnet2.id]
}
