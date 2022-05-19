variable "aws_account" {
  type        = string
  description = "AWS account owning the aws_ami."
}

variable "aws_ami" {
  type        = string
  description = "Name of the AWS AMI to be used."
}

variable "instance_type" {
  type        = string
  description = "Type of EC2 instance to provision"
  default     = "t2.micro"
}

variable "instance_name" {
  type        = string
  description = "EC2 instance name"
  default     = "algorand-node"
}

