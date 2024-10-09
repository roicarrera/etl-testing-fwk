terraform {
  backend "s3" {

    bucket = "conference-user-cb589b9c-tf-backend-bucket"
    key            = "etl/terraform.tfstate"
    region         = "eu-west-1"
    dynamodb_table = "conference-user-cb589b9c-tf-backend-dynamodb"

  }
}
















