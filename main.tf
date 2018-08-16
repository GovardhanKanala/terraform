provider  "aws" {
region = "us-east-1"
}

resource "aws_instance" "nginx" {
ami = "ami-cfe4b2b0"
instance_type = "t2.micro"
key_name = "jenkins-slave"
}
