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
#Provide
provider "aws" {
    region = "us-east-2"
    access_key = "${var.accesskey}"
    secret_key = "${var.secretkey}"
}
#Add key
resource "tls_private_key" "this" {
  algorithm = "RSA"
}

#Add instance
resource "aws_instance" "My_first_server" {
  ami = "ami-0fb653ca2d3203ac1"
  instance_type = "t2.xlarge"
  key_name = "AWS"
  vpc_security_group_ids = [aws_security_group.Allow_ssh.id]
  provisioner "file" {
    source      = "../project/"
    destination = "/home/ubuntu/"

    connection {
      type        = "ssh"
      user        = "ubuntu"
      private_key = "${file("${var.key}")}"
      host        = "${self.public_dns}"
    }
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
    Name = "allow_ssh"
  }
}
resource "local_file" "ip_output" {
  content = <<-DOC
  [build_servers]
  test_server1 ansible_host=${aws_instance.My_first_server.public_ip}
  DOC
  filename = "./inventory.txt"

  provisioner "local-exec" {
  command = "ansible-playbook --private-key '${var.key}' playbook.yml --extra-var \"login=${var.DockerLogin} psw=${var.DockerPsw}\" "
  }
}


output "Public_IP" {
  value = "${aws_instance.My_first_server.public_ip}"
}

