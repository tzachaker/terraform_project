# create ALB
resource "aws_lb" "tzach_alb" {
  internal           = false
  security_groups    = [aws_security_group.tzach_sg.id]
  subnets            = [aws_subnet.public_subnet.id]
}

# create target group
resource "aws_lb_target_group" "tzach_tg" {
  port     = 80
  protocol = "HTTP"
  vpc_id   = aws_vpc.tzach_vpc.id
}

# create auto scaling group
resource "aws_autoscaling_group" "asg" {
  desired_capacity     = 2
  max_size             = 3
  min_size             = 1
  vpc_zone_identifier  = [aws_subnet.public_subnet.id]
  target_group_arns    = [aws_lb_target_group.tzach_tg.arn]
  health_check_type    = "EC2"
  launch_configuration = aws_launch_configuration.web_instance.id
}

# בonfigure the EC2 instance and link to auto scaling group
resource "aws_launch_configuration" "web_instance" {
  image_id      = "ami-0ac80df6eff0e70b5" #AMI: Ubuntu 22.04
  instance_type = "t2.micro"
  security_groups = [aws_security_group.tzach_sg.id]
}

# create output to display the ALB DNS name
output "alb_dns_name" {
  value = aws_lb.tzach_alb.dns_name
}