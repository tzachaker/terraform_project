
provider "aws" {
  region = "us-east-1"  
}

# create a vpc named tzach_vpc
resource "aws_vpc" "tzach_vpc" {
  cidr_block = "10.0.0.0/16"
}

# create public subnet
resource "aws_subnet" "public_subnet" {
  vpc_id = aws_vpc.tzach_vpc.id
  cidr_block = "10.0.1.0/24"
  availability_zone = "us-east-1a"  
  map_public_ip_on_launch = true
}

# create private subnet
resource "aws_subnet" "private_subnet" {
  vpc_id = aws_vpc.tzach_vpc.id
  cidr_block = "10.0.2.0/24"
  availability_zone = "us-east-1a"  
}

# create internet gateway
resource "aws_internet_gateway" "internet_gatway" {
  vpc_id = aws_vpc.tzach_vpc.id
}

# create public route table 
resource "aws_route_table" "public_rt" {
  vpc_id = aws_vpc.tzach_vpc.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.internet_gatway.id
  }
}

# connect public subnet to route table
resource "aws_route_table_association" "public_rt_assoc" {
  subnet_id = aws_subnet.public_subnet.id
  route_table_id = aws_route_table.public_rt.id
}
