provider "aws" {
    region = "us-east-1"
}

resource "aws_db_instance" "example" {
    identifier_prefix = "terraform-up-and-running-prod"
    engine = "mysql"
    allocated_storage = 10
    instance_class = "db.t3.micro"
    skip_final_snapshot = true
    db_name = "example_database-prod"

    // How should we set the username and password?
    username = var.db_username
    password = var.db_password
}

terraform {
    backend "s3" {
        bucket = "terraform-up-and-running-state-kdd"
        key = "prod/data-stores/mysql/terraform.tfstate"
        region = "us-east-1"
      
        dynamodb_table = "terraform-up-and-running-locks"
        encrypt = true
    }
}