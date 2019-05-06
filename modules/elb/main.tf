resource "aws_elb" "test-stack" {
    name                    = "${var.application_name}-${var.environment}-elb"
    availability_zones      = "${var.availability_zones}"
    instances               = ["${var.attached_instances}"]
    access_logs {
        bucket              = "${var.log_bucket}"
        bucket_prefix       = "dev"
        interval            = 60
    }
    
    listener {
        instance_port       = 8000
        instance_protocol   = "http"
        lb_port             = 80
        lb_protocol         = "http"
    }

    health_check {
        healthy_threshold   = 2
        unhealthy_threshold = 2
        timeout             = 3
        target              = "HTTP:8000/"
        interval            = 30
    }
}   
