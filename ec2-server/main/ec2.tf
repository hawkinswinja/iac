resource "aws_default_security_group" "default" {
  vpc_id = aws_vpc.main.id

  ingress {
    cidr_blocks = ["0.0.0.0/0"]
    protocol  = "tcp"
    from_port = 80
    to_port   = 80
  }

  ingress {
    cidr_blocks = ["0.0.0.0/0"]
    protocol  = "tcp"
    from_port = 22
    to_port   = 22
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_instance" "main" {
  ami           = var.ami
  instance_type = var.instance-type
  associate_public_ip_address = true
  key_name = var.key-name
  subnet_id = aws_subnet.main.id

  connection {
    type     = "ssh"
    user     = "ubuntu"
    host     = self.public_ip
    private_key = file(var.private-key)
  }

  provisioner "file" {
    source      = "/tmp/docker-setup.sh"
    destination = "/tmp/script.sh"
  }

  provisioner "remote-exec" {
    inline = [
      "chmod +x /tmp/script.sh",
      "/tmp/script.sh",
    ]
  }


  tags = {
    Name = "main"
  }
}

resource "aws_eip" "bar" {
  domain = "vpc"
  instance                  = aws_instance.main.id
  depends_on                = [aws_internet_gateway.gw]
}
