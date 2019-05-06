provider "aws" {
		profile                 = "${var.aws_credentials_profile}"
		region                  = "${var.region}"
}

module "instances" {
		source                  = "./modules/instances"
		image_id                = "${data.aws_ami.latest-ubuntu.id}"
    number_of_instances     = "${var.number_of_instances}"
}

#Set up logging bucket
module "s3" {
  source                    = "./modules/s3"
  log_bucket                = "beren-g-test"
  prefix                    = "${var.environment}"
}

module "elb" {
    source                  = "./modules/elb"
    application_name        = "${var.application_name}"
    environment             = "${var.environment}"
    attached_instances      = [ "${module.instances.instance_ids}" ]
    log_bucket              = "${module.s3.bucket}"
}

