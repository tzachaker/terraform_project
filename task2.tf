# create security group with connect ssh and http
resource "aws_security_group" "tzach_sg" {
  vpc_id = aws_vpc.tzach_vpc.id
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

# EC2 instance in the public subnet
resource "aws_instance" "web_instance" {
  ami                    = "ami-0ac80df6eff0e70b5"  #AMI: Ubuntu 22.04
  instance_type           = "t2.micro"
  subnet_id               = aws_subnet.public_subnet.id
  associate_public_ip_address = true
  security_groups         = [aws_security_group.tzach_sg.name]  
}
# output of the public IP of the instance.
output "instance_public_ip_task2" {
  value = aws_instance.web_instance.public_ip
}
