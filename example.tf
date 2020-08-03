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
  name        = "allow_ssh"
  description = "Allow ssh inbound traffic"

  // allowing ssh
  ingress {
    description = "ssh from VPC"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  // allowing http
  ingress {
    description = "http"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "allow_ssh"
  }
}

resource "aws_instance" "codesenju" {
  ami             = "ami-07c76b7ba71f98b10" #Ubuntu
  instance_type   = "t3.micro"              #Free tier
  security_groups = [aws_security_group.my_sec.name]
  key_name        = "deploy_key" // the key-pair name created above
  tags = {
    Name = "codesenju"
  }

  connection {
    type        = "ssh"
    user        = "ubuntu"
    private_key = file("/project-folder/deploy_key.pem")
    host        = self.public_ip
  }

  #Install Docker on the vm
  provisioner "remote-exec" {
    inline = [
      "echo codesenju > hello.txt",
      "curl -fsSL https://get.docker.com -o get-docker.sh",
      "sudo sh get-docker.sh",
      "sudo docker run --name basic-httpd -d -p 80:80 codesenju/basic-httpd:latest"
    ]
  }


  depends_on = [
    aws_key_pair.deployer,
    aws_security_group.my_sec,
  ]
}

output "DNS" {
  value = aws_instance.codesenju.public_dns
}
