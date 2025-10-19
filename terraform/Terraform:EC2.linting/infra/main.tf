# Intentionally messy on purpose to trigger `terraform fmt -check`
terraform {
  required_version    =  ">= 1.5.0"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

provider "aws" {
  region= var.aws_region    # spacing is off (fmt)
}

# SECURITY NOTE: Opening 22 to the world is a bad idea; we'll let tfsec complain later
resource "aws_security_group" "ssh" {
  name        = "demo-ssh-sg"
  description = "Allow SSH"
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]   # intentionally permissive
  }
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

# INTENTIONAL LINT ERROR: bad instance type to trigger tflint aws rule
# (tflint-rule: aws_instance_invalid_type)
resource "aws_instance" "demo" {
  ami           = data.aws_ami.amazon_linux.id
  instance_type = "t2.mico"        # <-- typo; should be t2.micro
  vpc_security_group_ids = [aws_security_group.ssh.id]

  tags = {
    Name = "lint-demo"             # keep minimal; some orgs enforce extra tags
  }
}

# Data source for Amazon Linux 2
data "aws_ami" "amazon_linux" {
  most_recent = true
  owners      = ["amazon"]

  filter {
    name   = "name"
    values = ["amzn2-ami-hvm-*-x86_64-gp2"]
  }
}
