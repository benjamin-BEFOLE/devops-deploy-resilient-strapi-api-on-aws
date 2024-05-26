# Security group that will be attach to Application Load Balancer
resource "aws_security_group" "alb_sg" {
  name   = "strapi-alb-sg"
  vpc_id = aws_vpc.network.id
}

resource "aws_security_group_rule" "allow_all_ingress_traffic_alb_ipv4" {
  type              = "ingress"
  protocol          = "tcp"
  from_port         = 80
  to_port           = 80
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = aws_security_group.alb_sg.id
}

resource "aws_security_group_rule" "allow_traffic_out_alb_from_server" {
  type                     = "egress"
  protocol                 = "tcp"
  from_port                = 1337
  to_port                  = 1337
  source_security_group_id = aws_security_group.server_sg.id
  security_group_id        = aws_security_group.alb_sg.id
}

# Security group that will be attach to Strapi server
resource "aws_security_group" "server_sg" {
  name   = "strapi-server-sg"
  vpc_id = aws_vpc.network.id
}

resource "aws_security_group_rule" "allow_traffic_in_server_from_alb" {
  type                     = "ingress"
  protocol                 = "tcp"
  from_port                = 1337
  to_port                  = 1337
  source_security_group_id = aws_security_group.alb_sg.id
  security_group_id        = aws_security_group.server_sg.id
}

resource "aws_security_group_rule" "allow_all_egress_traffic_server_ipv4" {
  type              = "egress"
  protocol          = "tcp"
  from_port         = 0
  to_port           = 65535
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = aws_security_group.server_sg.id
}

# Security group that will be attach to Strapi database instance
resource "aws_security_group" "database" {
  name   = "strapi-database-sg"
  vpc_id = aws_vpc.network.id
}

resource "aws_security_group_rule" "allow_traffic_in_database_from_server" {
  type                     = "ingress"
  protocol                 = "tcp"
  from_port                = 5432
  to_port                  = 5432
  source_security_group_id = aws_security_group.server_sg.id
  security_group_id        = aws_security_group.database.id
}
