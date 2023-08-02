terraform {
    backend "s3" {
        bucket = "tf-backend-mj"
        key    = "development/terraform_state"
        region = "us-east-1"
    }
}