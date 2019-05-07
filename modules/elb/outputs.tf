output "id" {
  value = "${aws_elb.web.id}"
  # value = [ "${aws_instance.web.*.id}" ]
}