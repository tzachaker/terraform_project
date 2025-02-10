# variables
#vpc of CIDR
variable "vpc_cidr" {
  type        = string
}
#subnet count
variable "subnet_count" {
  type        = number
  default     = 2
}
#type of EC2
variable "instance_type" {
  type        = string
  default     = "t2.micro"
}
#ip public for ec2
variable "assign_public_ip" {
  type        = bool
  default     = true
}

# create vpc
resource "aws_vpc" "tzach_vpc" {
  cidr_block = var.vpc_cidr
}

# create subnets
resource "aws_subnet" "subnet" {
  count = var.subnet_count
  vpc_id = aws_vpc.tzach_vpc.id
  cidr_block = "10.0.${count.index + 1}.0/24"
}

# create EC2
resource "aws_instance" "web_instance" {
  ami = "ami-0ac80df6eff0e70b5"
  instance_type = var.instance_type
  subnet_id = aws_subnet.subnet[0].id
  associate_public_ip_address = var.assign_public_ip
}

# output of the public IP of the instance.
output "instance_public_ip" {
  value = aws_instance.web_instance.public_ip
}
