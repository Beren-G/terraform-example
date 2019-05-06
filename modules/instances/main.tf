resource "aws_instance" "web" {
  count                     = "${var.number_of_instances}"
  ami                       = "${var.image_id}"
  availability_zone         = "${var.availability_zone}"
  instance_type             = "t2.micro"
  tags = {
    Name                    = "test-stack-${count.index + 1}"
    # Environment             = "${}"
  }
}

