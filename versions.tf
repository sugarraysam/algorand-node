terraform {

  cloud {
    organization = "sugar-algorand"

    workspaces {
      name = "algorand-node"
    }
  }

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.14.0"
    }
  }

  required_version = "~> 1.1.9"
}
