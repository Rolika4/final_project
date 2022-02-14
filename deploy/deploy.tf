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

data "aws_eip" "java" {
  tags = {
    "Name" = "JavaEIP"
  }
}
data "aws_eip" "react" {
  tags = {
    "Name" = "JavaEIP"
  }
}


resource "local_file" "ip_output" {
  content = <<-DOC
  [java_server]
  java_server1 ansible_host=${data.aws_eip.java.public_ip}
  [react_server]
  react_server1 ansible_host=${data.aws_eip.react.public_ip}
  DOC
  filename = "./inventory.txt"
  provisioner "local-exec" {
  command = "ansible-playbook --private-key '${var.key}' deploy.yml --extra-var \"login=${var.DockerLogin} psw=${var.DockerPsw}\""
  }
}
