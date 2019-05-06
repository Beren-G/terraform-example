provider "aws" {
		profile                 = "${var.aws_credentials_profile}"
		region                  = "${var.region}"
}

data "aws_elb_service_account" "main" {}

resource "aws_s3_bucket" "elb_logs" {
  bucket = "beren-g-test"
  acl    = "private"
  force_destroy = true
  policy = <<POLICY
{
  "Id": "Policy",
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": [
        "s3:PutObject"
      ],
      "Effect": "Allow",
      "Resource": "arn:aws:s3:::beren-g-test/${var.environment}/*",
      "Principal": {
        "AWS": [
          "${data.aws_elb_service_account.main.arn}"
        ]
      }
    }
  ]
}
POLICY
}


module "instances" {
		source                  = "./modules/instances"
		image_id                = "${data.aws_ami.latest-ubuntu.id}"
    number_of_instances     = "${var.number_of_instances}"
}

module "elb" {
    source                  = "./modules/elb"
    application_name        = "${var.application_name}"
    environment             = "${var.environment}"
    attached_instances      = [ "${module.instances.instance_ids}" ]
    s3_bucket               = "${aws_s3_bucket.elb_logs.bucket}"
}

# Find latest Ubuntu 18.04 EBS backed image
data "aws_ami" "latest-ubuntu" {
most_recent                 = true
owners                      = ["099720109477"] # Amazon's ownder ID.
  filter {
      name                  = "name"
      values                = ["ubuntu/images/hvm-ssd/ubuntu-bionic-18.04-amd64-server-*"]
  }
  filter {
      name                  = "virtualization-type"
      values                = ["hvm"]
  }
  filter {
      name                  = "root-device-type"
      values                = [ "ebs" ]
  }
}






