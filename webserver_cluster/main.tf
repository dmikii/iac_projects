provider "aws" {
    region = "us-east-1"
}

resource "aws_launch_configuration" "launch_config" {
    image_id        = "ami-07d9b9ddc6cd8dd30"
    instance_type   = "t2.micro"
    security_groups = [aws_security_group.instance.id]

    user_data = <<-EOF
        #!/bin/bash
        echo "Hello, World" > index.html
        nohup busybox httpd -f -p ${var.server_port} &
        EOF

    // Required when using a launch configuration with an auto scaling group.
    lifecycle {
        create_before_destroy = true
    }  
}

resource "aws_autoscaling_group" "asg" {
    launch_configuration = aws_launch_configuration.launch_config.name
    vpc_zone_identifier  = data.aws_subnets.default.ids

    min_size = 2
    max_size = 10

    tag {
        key = "Name"
        value = "terraform-asg"
        propagate_at_launch = true
    }
}

resource "aws_security_group" "instance" {
    name = "terraform-instance"

    ingress {
        from_port   = var.server_port
        to_port     = var.server_port
        protocol    = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }
}

data "aws_vpc" "default" {
  default = true
}

data "aws_subnets" "default" {
  filter {
    name   = "vpc-id"
    values = [data.aws_vpc.default.id]
  }
}