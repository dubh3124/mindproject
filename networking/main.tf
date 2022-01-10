terraform {
  required_version = "1.1.2"
  required_providers {
    aws = "3.70.0"
  }
  backend "s3" {}
}

provider "aws" {
  region = var.region
  default_tags {
    tags = {
      project = var.project_alias
      environment = var.environment
    }
  }
}