terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.16"
    }
  }

  required_version = ">= 1.2.0"
}

provider "aws" {
  region = "us-west-2"
}

resource "aws_instance" "ceciltf" {
  ami                    = "ami-0aff18ec83b712f05" # Ubuntu 22.04 LTS (us-west-2)
  instance_type          = "t2.large"
  subnet_id              = "subnet-<omitted>"
  vpc_security_group_ids = ["sg-<omitted>"]

  tags = {
    "Name"           = "Cecil TF"
    "owner"       = "<omitted>"
    "project"     = "<omitted>"
    "environment" = "<omitted>"
  }
}

output "instance_id" {
  description = "ID of the EC2 instance"
  value       = aws_instance.ceciltf.id
}

output "instance_private_ip" {
  description = "Private IP address of the EC2 instance"
  value       = aws_instance.ceciltf.private_ip
}
