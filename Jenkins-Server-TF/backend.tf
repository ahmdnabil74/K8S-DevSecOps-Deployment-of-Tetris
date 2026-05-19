terraform {
  backend "s3" {
    bucket       = "dev-ahmed-tf-bucket"
    region       = "eu-central-1"
    key          = "e2e-DevSecOps-Tetris/Jenkins-Server-TF/terraform.tfstate"
    encrypt      = true
    use_lockfile = true
  }
  required_version = ">=1.13.3"
  required_providers {
    aws = {
      version = ">= 6.23.0"
      source  = "hashicorp/aws"
    }
  }
}