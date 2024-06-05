 variable "region" {
  default = "us-east-1"  # Default Region
}
 variable "main_vpc_cidr" {
  default = "10.0.0.0/24" # Default VPC
}
 variable "external_subnet" {
  default = "10.0.0.128/26" # External Subnet
}
 variable "internal_subnet" {
  default = "10.0.0.192/26" # Internal Subnet
}
 variable "aws_security_group" {
  default = "terraform_instruqt"# AWS Security Group name
}
variable "instance_names" {
  default = "test_terraform" # AWS Name of instance
}
variable "instance_type" {
  default = "t2.micro" # AWS Instance type
}