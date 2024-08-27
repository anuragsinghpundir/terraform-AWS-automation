#Almost Zero Downtime WebServer with Lifecycle and ElasticIP

provider "aws" {
}

resource "aws_instance" "web" {
  ami                    = "ami-0ad21ae1d0696ad58"
  key_name               = "terraform"
  instance_type          = "t3.micro"
  vpc_security_group_ids = [aws_security_group.web.id]
  user_data              = templatefile("user_data.sh.tpl", { f_name = "Anurag", l_name = "Pundir", names = ["John", "Andy", "Dante", "Vergil", "Nero"] })
  tags = {
    name  = "Webserver Built in Terraform 3"
    owner = "Anurag Singh Pundir"
  }
}

resource "aws_eip" "web" {
  instance = aws_instance.web.id
  tags = {
    name  = "EIP for webserver Built in Terraform"
    owner = "Anurag Singh Pundir"
  }
  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_security_group" "web" {
  name        = "webserver-sg"
  description = "security group for my webserver"
  dynamic "ingress" {
    for_each = ["80", "443"]
    content {
      description = "Allow Port HTTP"
      from_port   = ingress.value
      to_port     = ingress.value
      protocol    = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
    }

  }
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

}

