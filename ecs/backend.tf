terraform {
  backend "s3" {
    bucket = "stdeplsirl1"
    key    = "terraform/ecs"
    region = "eu-west-1"
    use_lockfile = true
  }

   # terraform with local backend
  # backend "local" {
  #   path = "./terraform.state" # explicit file to create for the statefile
  # }
}
