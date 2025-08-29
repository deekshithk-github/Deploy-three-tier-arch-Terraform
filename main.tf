provider "aws" {
  region = var.region
}

#Creating vpc and 2 subnets

resource "aws_vpc" "app_vpc" {
  cidr_block = var.vpc
}

resource "aws_subnet" "public_subnet" {
  vpc_id            = aws_vpc.app_vpc.id
  cidr_block        = var.pub-subnet
  map_public_ip_on_launch = true
}

resource "aws_subnet" "private_subnet" {
  vpc_id     = aws_vpc.app_vpc.id
  cidr_block = var.pvt-subnet
}

#Security_Groups

resource "aws_security_group" "frontend_sg" {
  name   = var.fe-sg
  vpc_id = aws_vpc.app_vpc.id

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_security_group" "backend_sg" {
  name   = var.be-sg
  vpc_id = aws_vpc.app_vpc.id

  ingress {
    from_port       = 3000
    to_port         = 3000
    protocol        = "tcp"
    security_groups = [aws_security_group.frontend_sg.id]
  }
}

resource "aws_security_group" "db_sg" {
  name   = var.db
  vpc_id = aws_vpc.app_vpc.id

  ingress {
    from_port       = 3306
    to_port         = 3306
    protocol        = "tcp"
    security_groups = [aws_security_group.backend_sg.id]
  }
}

#EC2 Instances Frontend + Backend
resource "aws_instance" "frontend" {
  ami           = var.ami # Ubuntu AMI
  instance_type = var.instance
  subnet_id     = aws_subnet.public_subnet.id
  vpc_security_group_ids = [aws_security_group.frontend_sg.id]

  user_data = file("user_data.sh")
  tags = { Name = "frontend-nodejs" }
}

resource "aws_instance" "backend" {
  ami           = var.ami
  instance_type = var.instance
  subnet_id     = aws_subnet.private_subnet.id
  vpc_security_group_ids = [aws_security_group.backend_sg.id]

  user_data = file("user_data.sh")
  tags = { Name = "backend-nodejs" }
}

# #RDS Database
# resource "aws_db_instance" "app_db" {
#   allocated_storage    = 20
#   engine               = "mysql"
#   engine_version       = "8.0"
#   instance_class       = "db.t3.micro"
#   #name                 = "appdb"
#   username             = "admin"
#   password             = "Password123!"
#   parameter_group_name = "default.mysql8.0"
#   skip_final_snapshot  = true
#   vpc_security_group_ids = [aws_security_group.db_sg.id]
#   db_subnet_group_name   = aws_db_subnet_group.db_subnet_group.name
# }

# resource "aws_db_subnet_group" "db_subnet_group" {
#   name       = "db-subnet-group"
#   subnet_ids = [aws_subnet.private_subnet.id]
# }

