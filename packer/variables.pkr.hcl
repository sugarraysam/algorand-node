variable "aws_access_key" {
  type    = string
  default = env("AWS_ACCESS_KEY_ID")
}

variable "aws_secret_key" {
  type    = string
  default = env("AWS_SECRET_ACCESS_KEY")
}

variable "aws_region" {
  type    = string
  default = env("AWS_REGION")
}

# Free tier eligible
# Ubuntu 22.04 LTS, SSD
# (last updated: 15-05-2022)
variable "src_ami" {
  type        = string
  default     = "ami-09d56f8956ab235b3"
  description = "The base AMI to be used."
}

variable "instance_type" {
  type        = string
  default     = "t2.micro"
  description = "EC2 instance type to use while building the AMI."
}


variable "dst_ami" {
  type        = string
  default     = env("TF_VAR_aws_ami")
  description = "The name of the final output AMI."
}
