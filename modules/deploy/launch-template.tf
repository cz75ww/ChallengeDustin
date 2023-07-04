
resource "aws_launch_template" "fpsouza_lt-staging" {
  name = "fpsouza-lt-staging"

  block_device_mappings {
    device_name = "/dev/sda1"

    ebs {
      volume_size = 20
    }
  }

  key_name = "cz75ww"

  #user_data = filebase64("${path.module}/scripts/webservers.sh")
  user_data = base64encode(<<-EOF
    #!/bin/bash
    
    # Update the OS
    apt update  -y
    apt upgrade -y
    
    # Install Ansible
    apt-add-repository ppa:ansible/ansible -y
    apt update -y
    apt install ansible -y
    sudo apt-get -y install git binutils
    git clone https://github.com/aws/efs-utils
    cd efs-utils/
    ./build-deb.sh
    apt-get -y install ./build/amazon-efs-utils*deb

    # Create the mount Point
    mkdir -p /var/www/html  
    mkdir /home/ubuntu/infra-as-code/
    echo " Sleeping per 60 seconds "
    sleep 60

    # Mounting EFS
    mount -t nfs4 -o nfsvers=4.1,rsize=1048576,wsize=1048576,hard,timeo=600,retrans=2 ${aws_efs_file_system.efs.dns_name}:/ /var/www/html

    # Making Mount Permanent
    echo '${aws_efs_file_system.efs.dns_name}:/ /var/www/html nfs4 defaults,_netdev 0 0'  >>  /etc/fstab
    chmod go+rw /var/www/html


    # Install Apache
    cd /home/ubuntu/infra-as-code/
    git clone https://github.com/cz75ww/ansible-apache.git
    cd /home/ubuntu/infra-as-code/ansible-apache/
    ansible-playbook playbook.yaml --diff > /tmp/nginx-install-$(date +'%Y-%m-%d').log


  EOF
  )

  
  image_id = data.aws_ami.ubuntu.id

  # instance_market_options {
  #   market_type = "spot"
  # }

  instance_type = "t2.micro" # t2.micro / t2.medium

  network_interfaces {
    associate_public_ip_address = false
    security_groups             = [aws_security_group.private_sg.id, aws_security_group.lb_sg.id]
  }

  tag_specifications {
    resource_type = "instance"

    tags = {
      Name = "fpsouza-staging"
    }
  }
}
