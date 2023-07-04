resource "aws_instance" "jumpserver" {
  count                       = 1
  ami                         = data.aws_ami.ubuntu.id
  instance_type               = "t2.micro"
  subnet_id                   = aws_subnet.public_subnet[count.index].id
  vpc_security_group_ids      = [aws_security_group.public_sg.id]
  associate_public_ip_address = true
  key_name                    = var.aws_key_name

  tags = {
    Name = var.server_tag_name
  }


  provisioner "remote-exec" {
    inline = ["echo 'Waiting for ssh connection'"]

    connection {
      type        = "ssh"
      user        = var.ssh_user
      private_key = file(var.aws_key_path)
      host        = aws_instance.jumpserver[count.index].public_ip
    }
  }
  provisioner "file" {
    source      = var.aws_key_path
    destination = "/home/ubuntu/.ssh/id_rsa"
    connection {
      type        = "ssh"
      user        = var.ssh_user
      private_key = file(var.aws_key_path)
      host        = self.public_ip
    }
  }

  user_data = <<-EOF
    #!/bin/bash
    
    # Update the OS
    sudo apt update  -y
    sudo apt upgrade -y
    sudo apt update  -y
    sudo apt upgrade -y

    # Change server name
    hostnamectl set-hostname jumpserver

    # Change key permission 
    chmod 600 /home/ubuntu/.ssh/id_rsa

  EOF
}

# resource "null_resource" "running_dsc" {

#   triggers = {
#     always_run = "${timestamp()}"
#   }

#   provisioner "local-exec" {
#     command = "ansible-playbook -i ${aws_instance.web.public_ip}, --private-key ${var.aws_key_path} ${var.ansible_path}"
#     }
# }