#####################################################################
#PROVIDER
#####################################################################
provider "aws" {
  access_key = "${var.aws_access_key}"
  secret_key = "${var.aws_secret_key}"
region       = "us-east-1"
}

######################################################################
#DATA
######################################################################
data "aws_availability_zones" "available" {}

######################################################################
#RESOURCE
######################################################################
# NETWORKING #
resource "aws_vpc" "vpc" {
    cidr_block            ="${var.network_address_space}"
    enable_dns_hostnames  = "true"
}

resource "aws_internet_gateway" "igw" {
    vpc_id                = "${aws_vpc.vpc.id}"
}

resource "aws_subnet" "subnet1" {
  cidr_block              = "${var.subnet1_address_space}"
  vpc_id                  ="${aws_vpc.vpc.id}"
  map_public_ip_on_launch = "true"
  availability_zone       = "${data.aws_availability_zones.available.names[0]}"
}

resource "aws_subnet" "subnet2" {
  cidr_block              = "${var.subnet2_address_space}"
  vpc_id                  = "${aws_vpc.vpc.id}"
  map_public_ip_on_launch = "true"
  availability_zone       = "${data.aws_availability_zones.available.names[1]}"
}
# ROUTING #

resource "aws_route_table" "rtb" {
  vpc_id                  = "${aws_vpc.vpc.id}"

 route {
   cidr_block             = "0.0.0.0/0"
   gateway_id             = "${aws_internet_gateway.igw.id}"
       }
}

resource "aws_route_table_association" "rta-subnet1" {
  subnet_id               = "${aws_subnet.subnet1.id}"
  route_table_id          = "${aws_route_table.rtb.id}"
}

resource "aws_route_table_association" "rta-subnet2" {
    subnet_id             = "${aws_subnet.subnet2.id}"
    route_table_id        = "${aws_route_table.rtb.id}"
}

# SECURITY GROUPS #
#Nginx security group
resource "aws_security_group" "nginx-sg" {
    name                  = "nginx_sg"
    vpc_id                = "${aws_vpc.vpc.id}"
}

#SSH access from anywhere
ingress {
  from_port               = 22
  to_port                 = 22
  protocol                = "tcp"
  cidr_blocks             = ["0.0.0.0/0"]
}

#HTTP access from anywhere
ingress {
  from_port               = 80
  to_port                 = 80
  protocol                = "tcp"
  cidr_blocks             = ["0.0.0.0/0"]
}

#Outbound internet access
egress {
  from_port               = 0
  to_port                 = 0
  protocol                = "-1"
  cidr_blocks             = ["0.0.0.0/0"]
}

# INSTANCES #
resource "aws_instance" "nginx1" {
  ami                     = "ami-c58c1dd3"
  instance_type           = "t2.micro"
  subnet_id               = "${aws_subnet.subnet1.id}"
  vpc_security_group_ids  = ["${aws_security_group.nginx-sg.id}"]
  key_name                = "${var.key_name}"
}
connection {
  user                    = "ec2-user"
  private_key             = "${file(var.private_key_Path)}"
}

provisioner "remote-exec" {
  inline                  = [
    "sudo yum install nginx -y",
    "sudo service nginx start",
    "echo '<html><head><title>Blue Team Server</title></head><body style =\"backgroud-color:#1
  ]
}
################################################################################
#output
################################################################################
output "aws_instance_public_dns"
{
  value                   = "${aws_instance.nginx1.public_dns}"
}
