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
    cidr_block              ="${var.network_address_space}"
    enable_dns_hostnames    = "true"
}

resource "aws_internet_gateway" "igw" {
    vpc_id                  = "${aws_vpc.vpc.id}"
    map_public_ip_on_launch = "true"
    availability_zone       = "{data.aws_availability_zones.available.names[0]}"
}

resource "aws_subnet" "subnet1" {
  cidr_block                = "${var.subnet1_address_space}"
  vpc_id                    ="${var.aws_vpc.vpc.id}"
  map_public_ip_on_launch   = "true"
  availability_zone         = "${data.aws.availability_zones.available.names[0]}"
}

resource "aws_subnet" "subnet2" {
  cidr_block                = "${var.subnet2_address_space}"
  vpc_id                    = "${var.vpc_id.vpc.id}"
  map_public_ip_on_launch   = "true"
  availability_zone         = "${data.aws.availability_zones.available.names[1]}"
}
