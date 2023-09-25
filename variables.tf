variable "vpc_cidr" {
   description = "this is the vpc cidr" 
   type = string
   default = "10.0.0.0/16"

}

variable "project_name" {
    description = "this is the name of our project"
    type = string
    default = "aws-2-tier"
}

variable "pub_sub_1" {
   description = "this is the public subnet 1 cidr" 
   type = string
   default = "10.0.1.0/24"

}

variable "pub_sub_2" {
   description = "this is the public subnet 2 cidr" 
   type = string
   default = "10.0.2.0/24"

}


variable "pri_sub_1" {
   description = "this is the private subnet 1 cidr" 
   type = string
   default = "10.0.3.0/24"

}

variable "pri_sub_2" {
   description = "this is the private subnet 2 cidr" 
   type = string
   default = "10.0.4.0/24"

}

variable "route_table_cidr" {
   description = "this is the route table cidr" 
   type = string
   default = "0.0.0.0/0"

}


variable "ami_id" {
    description = "ami for ec2 instances"
    type = string
    default = "ami-0cff7528ff583bf9a"
}


variable "db_username" {
  description = "Database administrator username"
  type        = string
  sensitive   = true
}

variable "db_password" {
  description = "Database administrator password"
  type        = string
  sensitive   = true
}