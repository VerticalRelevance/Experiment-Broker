provider "aws" {
  region = var.provider_region
  default_tags {
    tags = {
      Team = "ResiliencyTeam",
    }
  }
}