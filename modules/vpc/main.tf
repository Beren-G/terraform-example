resource "aws_launch_configuration" "as_conf" {
  name                      = "web_config"
  image_id                  = "${data.aws_ami.ubuntu.id}"
  instance_type             = "t2.micro"

  lifecycle {
    create_before_destroy   = true
  }
}

resource "aws_autoscaling_group" "web" {
  name                      = "${var.asg_name}"
  launch_configuration      = "${aws_launch_configuration.as_conf.name}"
  min_size                  = 1
  max_size                  = 2

  lifecycle {
    create_before_destroy = true
  }

  tags = {
    key                     = "Name"
    value                   = "web-asg"
    propagate_at_launch     = "true"
  }
}

resource "aws_vpc" "web" {
  cidr_block       = "10.0.0.0/16"
  instance_tenancy = "dedicated"

  tags = {
    Name = "web-vpc"
  }
}