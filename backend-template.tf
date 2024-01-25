terraform {

  # terraform with s3 backend

  backend "s3" {
    bucket = "" # existing bucket name
    key    = "" # identifier key as a file path
    region = "" # region 
  }

  # terraform with local backend
  backend "local" {
    path = "" # explicit file to create for the statefile
  }
 
}


