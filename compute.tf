data "aws_ami" "amazon_linux" {
  most_recent = true
  owners      = ["amazon"]

  filter {
    name   = "name"
    values = ["al2023-ami-2023.*-x86_64"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
}
resource "aws_instance" "web" {
  ami                         = data.aws_ami.amazon_linux.id
  instance_type               = "t3.micro"
  subnet_id                   = module.vpc.public_subnet_ids[0]
  vpc_security_group_ids      = [aws_security_group.web.id]
  associate_public_ip_address = true

  user_data = <<-EOF
              #!/bin/bash
              yum install -y nginx
              systemctl enable nginx
              systemctl start nginx
              echo "<h1>Hello from Terraform!</h1>" > /usr/share/nginx/html/index.html
              EOF

  tags = {
    Name    = "${var.project_name}-web-server"
    Project = var.project_name
  }
}
