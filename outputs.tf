output "vpc_id" {
  description = "ID of project VPC"
  value       = aws_vpc.vpc.id
}

output "igw_id" {
    value = aws_internet_gateway.igw.id
}

output "lb_dns_name" {
  description = "The DNS name of the load balancer"
  value       = "${aws_lb.alb.dns_name}"
}