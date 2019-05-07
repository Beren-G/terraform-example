# Configure S3 state storage
terraform {
  backend "s3" {
    bucket                  = "beren-terraform-state"
    key                     = "dev/state"
    region                  = "eu-west-2"
    dynamodb_table          = "terraform-lock"
  }
}

# Configure DynamoDB lock table
resource "aws_dynamodb_table" "state" {
  name                      = "terraform-lock"
  read_capacity             = 5
  write_capacity            = 5
  hash_key                  = "lock_id"
  attribute {
    name = "lock_id"
    type = "S"
  }
}

provider "aws" {
		profile                 = "${var.aws_credentials_profile}"
		region                  = "${var.region}"
}

module "asg" {
		source                  = "./modules/asg"
    asg_name                = "${var.application_name}-${var.environment}-asg"
    elb_id                  = "${module.elb.id}"
}

module "elb" {
    source                  = "./modules/elb"
    elb_name                = "${var.application_name}-${var.environment}"
    log_bucket              = "${module.s3.bucket}"
}

#Set up ELB logging bucket
module "s3" {
  source                    = "./modules/s3"
  log_bucket                = "${var.s3_bucket}"
  prefix                    = "${var.environment}"
}
