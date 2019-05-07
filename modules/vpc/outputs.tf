output "instance_ids" {
  value = [ "${aws_autoscaling_group.web.*.id}" ]
  # value = [ "${aws_instance.web.*.id}" ]
}