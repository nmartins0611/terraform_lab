# Use AWS provider for Terraform

provider "aws" {
  region = "us-east-1"
}

# Create the VPC

 resource "aws_vpc" "Main" {               
   cidr_block       = var.main_vpc_cidr     
   instance_tenancy = "default"
 }

 # Create gateway

 resource "aws_internet_gateway" "gateway" {    
    vpc_id =  aws_vpc.Main.id           
 }
 
 # Create external subnet

 resource "aws_subnet" "external_subnet" {   
   vpc_id =  aws_vpc.Main.id
   cidr_block = "${var.public_subnets}"      
 }
 
 # Create internal subnet 

 resource "aws_subnet" "internal_subnet" {
   vpc_id =  aws_vpc.Main.id
   cidr_block = "${var.private_subnets}"          
 }
 
# Routing table for external

 resource "aws_route_table" "routing_external" {   
    vpc_id =  aws_vpc.Main.id
         route {
    cidr_block = "0.0.0.0/0"              
    gateway_id = aws_internet_gateway.gateway.id
     }
 }
 
 # Routing table for internal

 resource "aws_route_table" "routing_internal" {   
   vpc_id = aws_vpc.Main.id
   route {
   cidr_block = "0.0.0.0/0"             
   nat_gateway_id = aws_nat_gateway.nat.id
   }
 }
 
 # Routing association for external

 resource "aws_route_table_association" "external_association" {
    subnet_id = aws_subnet.external_subnet.id
    route_table_id = aws_route_table.routing_external.id
 }

 # Routing association for internal

 resource "aws_route_table_association" "internal_association" {
    subnet_id = aws_subnet.internal_subnet.id
    route_table_id = aws_route_table.routing_internal.id
 }

 resource "aws_eip" "nateIP" {
   vpc   = true
 }

 # Resource for NAT 

 resource "aws_nat_gateway" "nat" {
   allocation_id = aws_eip.nateIP.id
   subnet_id = aws_subnet.external_subnet.id
 }

# Creating Security group

resource "aws_security_group" "terraform_group" {
  name        = "${var.aws_security_group}"  ## Survey - Add Security Group
  vpc_id      = aws_vpc.Main.id

  ## SSH access from anywhere

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks     = ["0.0.0.0/0"]
  
  }

  ## Custom Port option

  ingress {                                ## Survey - Add custom port
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
  ami           = "ami-06640050dc3f556bb"
  instance_type = "${var.instance_type}"  ## Survey - Add Instance type
  user_data = file("./cloud-init.conf")   ## Add user data for the instance
  tags = {
      Name = "${var.instance_names}"      ## Survey -  Add a tag for AWS
  }  
}
