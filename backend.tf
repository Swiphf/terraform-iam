terraform {
  backend "s3" {
    bucket = "ido-backend-iam-dev"
    key    = "terraform.tfstate"
    region = "eu-west-1"
  }
}