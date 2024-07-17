provider "aws" {
    region = "us-east-1"
}

resource "aws_instance" "example" {
    ami = "ami-07d9b9ddc6cd8dd30"
    instance_type = "t2.micro"
}

terraform {
    backend "s3" {
        bucket = "terraform-up-and-running-state-kdd"
        key = "workspaces-example/terraform.tfstate"
        region = "us-east-1"

        dynamodb_table = "terraform-up-and-running-locks"
        encrypt = true
    }
}