terraform {
  required_providers {
    aws = {
      source = "hashicorp/aws"
      version = "5.48.0"
    }
  }
}

provider "aws" {
  access_key = "**********************"
  secret_key = "****************************"
  region     = "ap-south-1"
}
