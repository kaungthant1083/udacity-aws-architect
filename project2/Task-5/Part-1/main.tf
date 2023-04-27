# TODO: Designate a cloud provider, region, and credentials
provider "aws" {
    region = "us-east-1"
    access_key = "your Access key"
    secret_key = "your AWS secret key"
    token = "your AWS token"
}

# TODO: provision 4 AWS t2.micro EC2 instances named Udacity T2
resource "aws_instance" "udacity-t2-instance" {
    ami = "ami-03c7d01cf4dedc891"
    instance_type = "t2.micro"
    subnet_id = "subnet-0b31654042b7374ab"
    count = 4
    key_name = "ec2-key"
    tags = {
        Name = "Udacity T2"
    }
  
}

# TODO: provision 2 m4.large EC2 instances named Udacity M4
resource "aws_instance" "udacity-m4-instance" {
    ami = "ami-03c7d01cf4dedc891"
    instance_type = "m4.large"
    subnet_id = "subnet-0b31654042b7374ab"
    count = 2
    key_name = "ec2-key"
    tags = {
        Name = "Udacity M4"
    }
  
}