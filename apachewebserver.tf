provider "aws" {
  region = "us-east-2"

}

resource "aws_instance" "web" {
  ami                    = "ami-0eea504f45ef7a8f7" #Ubuntu
  instance_type          = "t2.micro"
  vpc_security_group_ids = [aws_security_group.apache-security-group.id]

  user_data              = <<EOF
#!/bin/sh
 sudo apt-get update
 sudo apt install -y apache2
 sudo systemctl status apache2
 sudo systemctl start apache2
 sudo chown -R $USER:$USER /var/www/html
 sudo echo "<html><body><h1>this website was deployed using Terraform by Shey Njila `curl http://169.254.169.254/latest/meta-data/instance-id` </h1></body></html>" > /var/www/html/index.html
EOF

  tags = {
    Name  = "WebServer Built by Terraform"
    Owner = "Shey Njila"
  }
}

resource "aws_security_group" "apache-security-group" {
  name        = "WebServer-SG12"
  description = "Security Group for my WebServer"

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 443
    to_port     = 443
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
    Name  = "Server SG by Terraform"
    Owner = "Shey Njila"
  }

}


 
