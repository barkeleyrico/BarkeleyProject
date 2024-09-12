provider "aws" {
  region     = "ap-southeast-1"
}

resource "aws_instance" "example" {
  ami           = "ami-04a5ce820a419d6da"
  instance_type = "t2.micro"               # Type of EC2 instance

  # Optionally, add a tag to identify the instance
  tags = {
    Name = "terraform"
  }

  # Optional: Configure security group
  # vpc_security_group_ids = [aws_security_group.example.id]

  # Optional: Configure key pair (for SSH access)
  # key_name = "your-key-pair-name"  # Change to your key pair name
}

