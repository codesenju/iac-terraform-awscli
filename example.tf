provider "aws" {
  profile = "default"
  region  = "af-south-1"
}

//key creation
resource "aws_key_pair" "deployer" {
key_name = "deploy_key"
// enter the public key below
public_key = ""
}

// security group creation
resource "aws_security_group" "my_sec" {
name = "allow_ssh"
description = "Allow ssh inbound traffic"

// allowing ssh
ingress {
description = "ssh from VPC"
from_port = 22
to_port = 22
protocol = "tcp"
cidr_blocks = ["0.0.0.0/0"]
}
// allowing http
ingress {
description = "http"
from_port = 80
to_port = 80
protocol = "tcp"
cidr_blocks = ["0.0.0.0/0"]
}

egress {
from_port = 0
to_port = 0
protocol = "-1"
cidr_blocks = ["0.0.0.0/0"]
}

tags = {
Name = "allow_ssh"
}
}

resource "aws_instance" "example" {
  ami           = "ami-07c76b7ba71f98b10"
  instance_type = "t3.micro"
  security_groups = [ aws_security_group.my_sec.name ]
  key_name = "deploy_key" // the key-pair name created above
  tags = {
Name = "os2"
}
depends_on = [
aws_key_pair.deployer,
aws_security_group.my_sec,
]
}
