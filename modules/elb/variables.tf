variable "elb_name"     {}
variable "log_bucket"            {}
# variable "attached_instances"   {}

variable "number_of_instances" {
    description                 = "Number of instances to create and attach to ELB"
    default                     = 1
}

variable "availability_zones"   {
    type                        = "list"
    default                     = [ "eu-west-2a" ]
}