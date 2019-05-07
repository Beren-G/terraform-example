output "bucket" {
  value = "${aws_s3_bucket.elb_logs.bucket}"
  # value = [ "${aws_instance.web.*.id}" ]
}