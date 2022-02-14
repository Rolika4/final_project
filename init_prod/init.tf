variable "key" {
  default = {}
}
variable "accesskey" {
  default = {}
}
variable "secretkey" {
  default = {}
}
variable "DockerLogin" {
  default = {}
}
variable "DockerPsw" {
  default = {}
}
provider "aws" {
  region = "us-east-2"
  access_key = "${var.accesskey}"
  secret_key = "${var.secretkey}"
}
resource "tls_private_key" "this" {
  algorithm = "RSA"
}
resource "aws_eip_association" "java_static_ip" {
  instance_id  = aws_instance.Java_Server.id
  allocation_id = "${data.aws_eip.public.id}"
}
data "aws_eip" "public" {
  tags = {
    "Name" = "JavaEIP"
  }
}
resource "aws_eip" "react_static_ip" {
  instance  = aws_instance.React_server.id
  tags = {
    "Name" = "ReactEIP"
  }
}
resource "aws_instance" "Java_Server" {
  ami = "ami-0fb653ca2d3203ac1"
  instance_type = "t2.micro"
  key_name = "AWS"
  vpc_security_group_ids = [aws_security_group.allowHTTP.id, aws_security_group.Allow_ssh.id]
  tags = {
      Name = "Java app server"
      Owner = "Nick Serdiuk"
      Project = "Epam final project"
  }
}
resource "aws_instance" "React_server" {
  ami = "ami-0fb653ca2d3203ac1"
  instance_type = "t2.micro"
  key_name = "AWS"
  vpc_security_group_ids = [aws_security_group.allowHTTP.id, aws_security_group.Allow_ssh.id]
  tags = {
      Name = "React app server"
      Owner = "Nick Serdiuk"
      Project = "Epam final project"
  }
}

#Add resource group 
resource "aws_security_group" "Allow_ssh" {
  name        = "Allow_ssh"
  description = "Allow SSH inbound traffic"

  ingress {
    description      = "TLS from VPC"
    from_port        = 22
    to_port          = 22
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
  }
  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }
  tags = {
    Name = "SSH"
    Port = "22"
    Owner = "Nick Serdiuk"
    Resources = "Add ssh access"
    Project = "Epam final project"
  }
}
resource "aws_security_group" "allowHTTP" {
  name        = "Allow_HTTP"
  description = "Allow HTTP inbound traffic"

  ingress {
    description      = "Allow tcp/80 port"
    from_port        = 80
    to_port          = 80
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
  }
  ingress {
    description      = "Allow tcp/8080 port"
    from_port        = 8080
    to_port          = 8080
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
  }
  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }
  tags = {
    Name = "HTTP"
    Port = "80, 8080"
    Owner = "Nick Serdiuk"
    Resources = "Java app, React app"
    Project = "Epam final project"
  }
}

resource "local_file" "ip_output" {
  content = <<-DOC
  [java_server]
  java_server1 ansible_host=${aws_eip_association.java_static_ip.public_ip}
  [react_server]
  react_server1 ansible_host=${aws_eip.react_static_ip.public_ip}
  DOC
  filename = "./inventory.txt"
  provisioner "local-exec" {
  command = "ansible-playbook --private-key '${var.key}' init.yml --extra-var \"login=${var.DockerLogin} psw=${var.DockerPsw}\""
  }
      connection {
      type        = "ssh"
      user        = "ubuntu"
      private_key = "AWS"
      host        = "${aws_eip_association.java_static_ip.public_ip}, ${aws_eip.react_static_ip.public_ip}"
    }
}
