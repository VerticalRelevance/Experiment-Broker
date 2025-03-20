terraform {
  backend "s3" {
    dynamodb_table = "experiment-broker-terraform-state-demo"
    bucket         = "experiment-broker-backend-bucket-demo"
    region         = "us-east-1"
    key            = "experiment_broker.terraform.tfstate"
  }
}

provider "aws" {
  region = "us-east-1"
  default_tags {
    tags = {
      Team = "ResiliencyTeam",
    }
  }
}