terraform {
    backend "s3" {
        bucket = "tf-backend-mj"
        key    = "development/terraform_state"
        region = "us-east-1"
    }
}

provider "aws" {
  region     = var.AWS_REGION
}