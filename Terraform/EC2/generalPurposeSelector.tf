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
  region = "<region>"
}

variable "instance_type" {
  description = "The size of the EC2 instance. Choose from: t2.micro (1 vCPU, 1GB RAM), t2.small (1 vCPU, 2GB RAM), t2.medium (2 vCPU, 4GB RAM), t2.large (2 vCPU, 8GB RAM), t3.micro (2 vCPU, 1GB RAM), t3.small (2 vCPU, 2GB RAM), t3.medium (2 vCPU, 4GB RAM), t3.large (2 vCPU, 8GB RAM)"
  type        = string


  validation {
    condition     = contains(["t2.micro", "t2.small", "t2.medium", "t2.large", "t3.micro", "t3.small", "t3.medium", "t3.large"], var.instance_type)
    error_message = "Invalid instance type! The allowed values are: t2.micro, t2.small, t2.medium, t2.large, t3.micro, t3.small, t3.medium, t3.large"
  }
}

variable "key_name" {
  description = "Name of the AWS key pair to use for the instance"
  type        = string
  default     = "<target_key>"
}

resource "aws_instance" "ceciltf" {
  ami                    = "ami-0aff18ec83b712f05" # Ubuntu 22.04 LTS (us-west-2)
  instance_type          = var.instance_type
  key_name               = var.key_name
  subnet_id              = "subnet-<omitted>"
  vpc_security_group_ids = ["sg-<omitted>"]

  tags = {
    "Name"           = "Cecil Terraform"
    "<omitted>"       = "<omitted>"
    "<omitted>"     = "<omitted>"
    "<omitted>" = "<omitted>"
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

#Write out a text file called "private_ip.txt" to the current working directory
resource "local_file" "private_ip" {
  content  = aws_instance.ceciltf.private_ip
  filename = "${path.module}/private_ip.txt"
}
