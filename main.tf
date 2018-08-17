provider  "aws" {
  access_key = "${var.aws_access_key}"
  secret_key = "${var.aws_secret_key}"
region = "us-east-1"

}

resource "aws_instance" "nginx" {
ami = "ami-cfe4b2b0"
instance_type = "t2.micro"
key_name = "jenkins-slave"
}
