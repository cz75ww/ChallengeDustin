terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 3.0"
    }
  }
}

provider "aws" {
  region = "us-east-1"
}

terraform {
  backend "s3" {
    bucket = "fpsouza-bootcamp-infra-as-code"
    key    = "bootcamp/staging/terraform.tfstate"
    region = "us-east-1"
  }
}