terraform {
  backend "s3" {
    bucket         = "conference-user-1-etl-testing-fwk-backend-s3"
    key            = "etl-testing-fwk/dev/terraform.tfstate"
    region         = "eu-west-1"
    dynamodb_table = "conference-user-1-manage-users-dynamodb"
  }
}