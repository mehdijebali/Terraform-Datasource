terraform {
    backend "s3" {
        bucket = "tf-s3-backend"
        key    = "development/terraform_state"
        region = "us-east-1"
    }
}