terraform {
  backend "s3" {
    bucket = "ghw-statefiles"
    key    = "ec2-server"
    region = "us-east-1"
  }
}

