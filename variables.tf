# Local application environment setup. This would normally be in .gitignore

variable "application_name"        { default = "test-stack" }

variable "environment"             { default = "dev" }

variable "region"                  { default = "eu-west-2" }

variable "aws_credentials_profile" { default = "terraform" }

variable "s3_bucket"               { default = "beren-g-test" }

variable "number_of_instances" {
    description                             = "Number of instances to create and attach to ELB"
    default                                 = 2
}
