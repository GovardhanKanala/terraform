####################################################################
#variables
####################################################################

variable "aws_access_key" {
  default = ""
}

variable "aws_secret_key" {
  default = ""
}

variable "private_key_path" {
  default = "/var/jenkins_home/.ssh/id_rsa"
}
variable "PATH_TO_PUBLIC_KEY" {
  default = "/var/jenkins_home/.ssh/id_rsa.pub"
}

variable "key_name" {
  default = "terraform_key"
}

variable "network_address_space" {
  default = "10.1.0.0/16"
}
variable "subnet1_address_space" {
  default = "10.1.0.0/24"
}
variable "subnet2_address_space" {
  default = "10.1.1.0/24"
}
variable "billing_code_tag" {
  default = "ACCT86753176"
}
variable "environment_tag" {
  default = "dev"
}
variable "bucket_name" {
  default = "globomantics-web-dev"
}
