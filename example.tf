provider "aws" {
  profile = "default"
  region  = "af-south-1"
}

resource "aws_instance" "example" {
  ami           = "ami-07c76b7ba71f98b10"
  instance_type = "t3.micro"
}