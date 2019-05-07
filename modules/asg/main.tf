# Set up ubuntu launch config with basic HTTP responder
resource "aws_launch_configuration" "as_conf" {
  name                      = "web_config"
  image_id                  = "${data.aws_ami.ubuntu.id}"
  instance_type             = "t2.micro"
  key_name                  = "Beren-EC2"
  #security_groups          = []
  user_data = <<EOF
#!/bin/bash
echo "Hello from $(hostname)" > index.html
nohup busybox httpd -f -p 8000 &
EOF

 lifecycle {
    create_before_destroy   = true
  }
}

# ASG
resource "aws_autoscaling_group" "web" {
  name                      = "${var.asg_name}"
  launch_configuration      = "${aws_launch_configuration.as_conf.name}"
  availability_zones        = [ "${var.availability_zones}" ] #ToDo - move to VPC
  
  min_size                  = 1
  max_size                  = 2
  
  enabled_metrics           = ["GroupMinSize", "GroupMaxSize", "GroupDesiredCapacity", "GroupInServiceInstances", "GroupTotalInstances"]
  metrics_granularity       = "1Minute"
  health_check_type         = "ELB"
  lifecycle {
    create_before_destroy   = true
  }
  

  load_balancers            = [ "${var.elb_id}" ]
  
  tags = {
    key                     = "Name"
    value                   = "web-asg"
    propagate_at_launch     = "true"
  }
}

# ASG policy
resource "aws_autoscaling_policy" "web" {
  name                      = "${var.asg_name}-asg-policy"
  scaling_adjustment        = 1
  adjustment_type           = "ChangeInCapacity"
  cooldown                  = 300
  autoscaling_group_name    = "${aws_autoscaling_group.web.name}"
}

# SNS topic for below metric alarms
resource "aws_sns_topic" "web" {
  name = "${var.asg_name}-topic"
}

# CPU Utilization metric with SNS and autoscaling actions
resource "aws_cloudwatch_metric_alarm" "web" {
  alarm_name                = "${var.asg_name}-asg-alarm"
  comparison_operator       = "GreaterThanOrEqualToThreshold"
  evaluation_periods        = "1" #super low for testing
  metric_name               = "CPUUtilization"
  namespace                 = "AWS/EC2"
  period                    = "60"
  statistic                 = "Average"
  threshold                 = "80"

  dimensions                = {
    AutoScalingGroupName    = "${aws_autoscaling_group.web.name}"
  }

  alarm_description         = "This metric monitors ec2 cpu utilization"
  alarm_actions             = ["${aws_autoscaling_policy.web.arn}", "${aws_sns_topic.web.arn}"]
}