resource "aws_vpc" "default" {
  cidr_block = "10.0.0.0/16"
}

resource "aws_subnet" "public" {
  vpc_id = aws_vpc.default.id
  cidr_block = "10.0.1.0/24"
}

resource "aws_subnet" "private" {
  vpc_id = aws_vpc.default.id
  cidr_block = "10.0.2.0/24"
}

resource "aws_internet_gateway" "default" {
  vpc_id = aws_vpc.default.id
}

resource "aws_route_table" "public" {
  vpc_id = aws_vpc.default.id
  route {
    gateway_id = aws_internet_gateway.default.id
    cidr_block = "0.0.0.0/0"
  }
}

resource "aws_route_table_association" "public" {
  subnet_id = aws_subnet.public.id
  route_table_id = aws_route_table.public.id
}

resource "aws_load_balancer" "frontend" {
  name = "my-frontend-load-balancer"
  subnets = [aws_subnet.public.id]
  type = "application"
}

resource "aws_ec2_instance" "frontend_1" {
  ami = "ami-1234567890"
  instance_type = "t2.micro"
  subnet_id = aws_subnet.public.id
  security_groups = [aws_security_group.frontend.id]
}

resource "aws_ec2_instance" "frontend_2" {
  ami = "ami-1234567890"
  instance_type = "t2.micro"
  subnet_id = aws_subnet.public.id
  security_groups = [aws_security_group.frontend.id]
}

resource "aws_load_balancer" "application" {
  name = "my-application-load-balancer"
  subnets = [aws_subnet.private.id]
  type = "application"
}

resource "aws_ec2_instance" "application_1" {
  ami = "ami-1234567890"
  instance_type = "t2.micro"
  subnet_id = aws_subnet.private.id
  security_groups = [aws_security_group.application.id]
}

resource "aws_ec2_instance" "application_2" {
  ami = "ami-1234567890"
  instance_type = "t2.micro"
  subnet_id = aws_subnet.private.id
  security_groups = [aws_security_group.application.id]
}

resource "aws_rds_instance" "database" {
  engine = "mysql"
  instance_class = "db.t2.micro"
  name = "my-database"
  username = "root"
  password = "password"
  db_name = "my-database"
  subnet_id = aws_subnet.private.id
}