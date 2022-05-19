# Required config is exported in env
# https://registry.terraform.io/providers/hashicorp/aws/latest/docs#environment-variables
provider "aws" {}

data "aws_ami" "algorand" {
  most_recent = true

  filter {
    name   = "name"
    values = [var.aws_ami]
  }

  owners = [var.aws_account]
}

resource "aws_instance" "algorand" {
  ami           = data.aws_ami.algorand.id
  instance_type = var.instance_type

  tags = {
    Name = var.instance_name
  }
}
