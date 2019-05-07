# Find latest Ubuntu 18.04 EBS backed image
data "aws_ami" "ubuntu" {

most_recent                 = true

owners                      = ["099720109477"] # Amazon's ownder ID.

  filter {
      name                  = "name"
      values                = ["ubuntu/images/hvm-ssd/ubuntu-bionic-18.04-amd64-server-*"]
  }

  filter {
      name                  = "virtualization-type"
      values                = ["hvm"]
  }

  filter {
      name                  = "root-device-type"
      values                = [ "ebs" ]
  }
}
