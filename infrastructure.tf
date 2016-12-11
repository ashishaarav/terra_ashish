#_credentials_fileAWS provider
provider "aws" {
  region                   = "${var.aws_region}"
  shared_credentials_file  = "${var.aws_credentials_file}"
  profile                  = "${var.aws_profile}"
}
// key pair
resource "aws_key_pair" "ec2_key" {
  key_name   = "${var.ssh_public_key_name}"
  public_key = "${var.ssh_public_key}"
}
data "aws_ami" "base_image" {
  most_recent = true
filter {
    name = "name"
    values = ["ubuntu/images/ebs/ubuntu-trusty-14.04-amd64-server-*"]
  }
}

resource "aws_instance" "web" {
    ami = "${data.aws_ami.base_image.id}"
    instance_type = "t1.micro"
    key_name               = "${aws_key_pair.ec2_key.key_name}"
    vpc_security_group_ids = ["${aws_security_group.allow_all1.id}"]
    tags {
        Name = "Ashish_test"
    }
}
resource "aws_security_group" "allow_all1" {
  name = "allow_all1"
  description = "Allow all inbound traffic"

  ingress {
      from_port = 22
      to_port = 22
      protocol = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
      from_port = 22
      to_port = 22
      protocol = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
  }
}
output "awshosts" {
 value = ["${aws_instance.web.public_ip}"]
}
