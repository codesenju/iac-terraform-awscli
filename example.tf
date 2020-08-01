provider "aws" {
  profile = "default"
  region  = "af-south-1"
}

//key creation
resource "aws_key_pair" "deployer" {
key_name = "deploy_key"
// enter the public key below
public_key = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAACAQCwLPO7LRZNdB84pZDgKqzcA04lhG20lRsZLdN4bQxVC98tFp1aiEigOKrMvDP2U/ZSN7e4nYgN4iTl56QC+CE1egMuUy0jYznZLiZ94+9KzdGL9KzAmFvj8ZUaLo9VClNNBHKjTQKGcI/TmPOPqxZisn2K26qtoW15w4XB2Tm6SrSbz91VTHkHblyeQl5v/1H3cV6BDh1vnoOgSdV+UFSML7T7to7eJjNa/51ifH9Ahma0sA1tXMr3BJ6A0PFy83aciXpxyyvn58zVl+evXZhLNzwxZ3hw3uiJm14nCaz3N0txvz/eoClqtnEvL2YttmR4iIDapqYV/1uu4i+lP2N/kQI0E7j+y7xNXp+Af7LNbr948PtSEjNs2mchtBSszjZSi6xZnQd/a0pUwAMpdppn1QPo5Lp1S5k3m2SD83nK7kWkI2TGR9XhxgJGS/vtkeXoj3KkdDbKGBH44xRrroZoXQYNFovNYbsLKFxjnrvGYmCKK9jaJJbJtX7DOLP2KFm1DLnof89PP7aZMKBcc1rfigUsNUvfL6hjm1xp3+FMCJvO/TECg3hGBsE9X2uy7znNZhVqlK/ilaAydaqtYBtWu7yXQbTHS2Tf7vbC0mpzykHldgWbfXAx3WbWBwjZ7D/X7Cnl3ssizYfxINKEJiaSm+Vsc8lR4DFSOUChBrz9PQ== Lehlogonolo.Masubelele@ibm.com"
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
