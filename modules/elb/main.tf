# ELB with logging to S3
resource "aws_elb" "web" {
    name                    = "${var.elb_name}-elb"
    availability_zones      = "${var.availability_zones}"
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

# Unhealthy Host Alarm with SNS action
resource "aws_cloudwatch_metric_alarm" "unhealthy" {
  alarm_name                = "${var.elb_name}-alarms"
  comparison_operator       = "GreaterThanOrEqualToThreshold"
  evaluation_periods        = "1" # set low for testing
  metric_name               = "UnHealthyHostCount" 
  namespace                 = "AWS/EC2"
  period                    = "60"
  statistic                 = "Average"
  threshold                 = "1"
  alarm_description         = "This metric monitors unhealthy host status"
  insufficient_data_actions = []
  alarm_actions             = [ "${aws_sns_topic.web.arn}" ]
  dimensions                = {
    LoadBalancerName        = "${aws_elb.web.name}"
  }
}

# SNS topic for alarm output
resource "aws_sns_topic" "web" {
  name                      = "${var.elb_name}-topic"
}