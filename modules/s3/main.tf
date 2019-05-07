# S3 Bucket for logging

# Force destroy enabled !!!!!!!!!!!
resource "aws_s3_bucket" "elb_logs" {
  bucket                    = "${var.log_bucket}"
  acl                       = "private"
  force_destroy             = true
  policy = <<POLICY
{
  "Id": "Policy",
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": [
        "s3:PutObject"
      ],
      "Effect": "Allow",
      "Resource": "arn:aws:s3:::beren-g-test/${var.prefix}/*",
      "Principal": {
        "AWS": [
          "${data.aws_elb_service_account.main.arn}"
        ]
      }
    }
  ]
}
POLICY
}