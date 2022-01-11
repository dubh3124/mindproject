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

data "terraform_remote_state" "nlpnetwork" {
  backend = "s3"
  config = {
    bucket = "nlp-terraform-state-bucket-879y081234"
    key = "nlpnetwork.tfstate"
    region = var.region
  }
}

data "terraform_remote_state" "nlpappinfra" {
  backend = "s3"
  config = {
    bucket = "nlp-terraform-state-bucket-879y081234"
    key = "nlpappinfra.tfstate"
    region = var.region
  }
}