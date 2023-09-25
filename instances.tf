
# ec2 instances

resource "aws_instance" "web_1" {
  ami           = var.ami_id
  instance_type = "t2.micro"
  associate_public_ip_address = true
  availability_zone = data.aws_availability_zones.available.names[0]
  subnet_id = aws_subnet.public_subnet_1.id
  vpc_security_group_ids = [aws_security_group.web_sg.id]
  user_data = file("config.sh")


  tags = {
    Name = "${var.project_name}-web_1"
  }
}


resource "aws_instance" "web_2" {
  ami           = var.ami_id
  instance_type = "t2.micro"
  associate_public_ip_address = true
  availability_zone = data.aws_availability_zones.available.names[1]
  subnet_id = aws_subnet.public_subnet_2.id
  vpc_security_group_ids = [aws_security_group.web_sg.id]
  user_data = file("config.sh")
  
  tags = {
    Name = "${var.project_name}-web_2"
  }
}



#db subnet group

resource "aws_docdb_subnet_group" "db_group" {
  name       = "db_group"
  subnet_ids = [aws_subnet.private_subnet_1.id, aws_subnet.private_subnet_2.id]

}


# db instances

resource "aws_db_instance" "mydb" {
  allocated_storage    = 10
  db_name              = "mydb"
  engine               = "mysql"
  engine_version       = "5.7"
  instance_class       = "db.t3.micro"
  username             = var.db_username
  password             = var.db_password
  db_subnet_group_name = aws_docdb_subnet_group.db_group.id
  vpc_security_group_ids = [aws_security_group.db_sg.id]
  publicly_accessible = false
  skip_final_snapshot  = true
}