provider "aws" {
  region = "eu-west-2"
}

resource "aws_security_group" "terraform_group" {

  # SSH access from anywhere

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks     = ["0.0.0.0/0"]

  }

  # HTTP access from the VPC

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks     = ["0.0.0.0/0"]
  }

    egress {
    from_port       = 0
    to_port         = 0
    protocol        = "-1"
    cidr_blocks     = ["0.0.0.0/0"]
    }
}

resource "aws_instance" "basic_rhel" {
  ami           = "ami-035c5dc086849b5de"
  instance_type = "t2.micro"
}