#vpc block

resource "aws_vpc" "vpc" {
  cidr_block       = var.vpc_cidr
  instance_tenancy = "default"

  tags = {
    Name = "${var.project_name}-vpc"
  }
}

# internet gw

resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.vpc.id

  tags = {
    Name = "${var.project_name}-igw"
  }
}

#az data source

# Declare the data source
data "aws_availability_zones" "available" {
  state = "available"
}

#public subnet-1

resource "aws_subnet" "public_subnet_1" {
  vpc_id     = aws_vpc.vpc.id
  cidr_block = var.pub_sub_1
  availability_zone = data.aws_availability_zones.available.names[0]
  map_public_ip_on_launch = true

  tags = {
    Name = "${var.project_name}-public-subnet-1"
  }
}

#public subnet-2

resource "aws_subnet" "public_subnet_2" {
  vpc_id     = aws_vpc.vpc.id
  cidr_block = var.pub_sub_2
  availability_zone = data.aws_availability_zones.available.names[1]
  map_public_ip_on_launch = true

  tags = {
    Name = "${var.project_name}-public-subnet-2"
  }
}


#private subnet-1

resource "aws_subnet" "private_subnet_1" {
  vpc_id     = aws_vpc.vpc.id
  cidr_block = var.pri_sub_1
  availability_zone = data.aws_availability_zones.available.names[0]

  tags = {
    Name = "${var.project_name}-private-subnet-1"
  }
}

#private subnet-2

resource "aws_subnet" "private_subnet_2" {
  vpc_id     = aws_vpc.vpc.id
  cidr_block = var.pri_sub_2
  availability_zone = data.aws_availability_zones.available.names[1]

  tags = {
    Name = "${var.project_name}-private-subnet-2"
  }
}

# route table to internet gateway

resource "aws_route_table" "route_table" {
  vpc_id = aws_vpc.vpc.id

  route {
    cidr_block = var.route_table_cidr
    gateway_id = aws_internet_gateway.igw.id
  }

  tags = {
    Name = "${var.project_name}-route-table"
  }
}

# route table association to both public subnets

resource "aws_route_table_association" "pub_sub_1_association" {
  subnet_id      = aws_subnet.public_subnet_1.id
  route_table_id = aws_route_table.route_table.id
}

resource "aws_route_table_association" "pub_sub_2_association" {
  subnet_id      = aws_subnet.public_subnet_2.id
  route_table_id = aws_route_table.route_table.id
}


# load balancer


resource "aws_lb" "alb" {
  name               = "alb"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.alb_sg.id]
  subnets            = [aws_subnet.public_subnet_1.id, aws_subnet.public_subnet_2.id]

  #enable_deletion_protection = true

  tags = {
    Environment = "${var.project_name}-alb"
  }
}

# alb target group

resource "aws_lb_target_group" "alb_tg" {
  name        = "alb-tg"
  port        = 80
  protocol    = "HTTP"
  vpc_id      = aws_vpc.vpc.id

  depends_on = [aws_vpc.vpc]
}


# alb target group attachments

# attachment-1

resource "aws_lb_target_group_attachment" "tg_attch_1" {
  target_group_arn = aws_lb_target_group.alb_tg.arn
  target_id        = aws_instance.web_1.id
  port = 80

  depends_on       = [aws_instance.web_1]
}


# attachment-2

resource "aws_lb_target_group_attachment" "tg_attch_2" {
  target_group_arn = aws_lb_target_group.alb_tg.arn
  target_id        = aws_instance.web_2.id
  port = 80

  depends_on       = [aws_instance.web_2]
}



# create alb listener 

resource "aws_lb_listener" "alb_listener" {
  load_balancer_arn = aws_lb.alb.arn 
  port              = 80
  protocol          = "HTTP"


  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.alb_tg.arn
  }
}