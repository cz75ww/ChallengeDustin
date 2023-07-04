resource "aws_security_group" "public_sg" {
  name   = "fpsouza-public-sg-staging"
  vpc_id = aws_vpc.vpc.id

  dynamic "ingress" {
    for_each = var.ingress_ssh_ports # Jump Server
    content {
      from_port   = ingress.value
      to_port     = ingress.value
      protocol    = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
    }
  }
  ingress {
    from_port   = -1
    to_port     = -1
    protocol    = "icmp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "fpsouza-public-sg-staging"
  }
}

resource "aws_security_group" "lb_sg" {
  name   = "fpsouza-lb-sg-staging"
  vpc_id = aws_vpc.vpc.id

  dynamic "ingress" {
    for_each = var.ingress_lb_ports
    content {
      from_port   = ingress.value
      to_port     = ingress.value
      protocol    = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
    }
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
  tags = {
    Name = "fpsouza-lb-sg-staging"
  }
}

resource "aws_security_group" "private_sg" {
  name   = "fpsouza-private-sg-staging"
  vpc_id = aws_vpc.vpc.id

  dynamic "ingress" {
    for_each = var.ingress_private_ports
    content {
      from_port       = ingress.value
      to_port         = ingress.value
      protocol        = "tcp"
      security_groups = [aws_security_group.lb_sg.id, aws_security_group.public_sg.id]


    }
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
  tags = {
    Name = "fpsouza-private-sg-staging"
  }
}

resource "aws_security_group" "efs_sg" {
  name   = "fpsouza-efs-sg-staging"
  vpc_id = aws_vpc.vpc.id

  dynamic "ingress" {
    for_each = var.ingress_private_ports
    content {
      from_port       = ingress.value
      to_port         = ingress.value
      protocol        = "tcp"
      security_groups = [aws_security_group.lb_sg.id, aws_security_group.public_sg.id, aws_security_group.private_sg.id]


    }
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
  tags = {
    Name = "fpsouza-efs-sg-staging"
  }
}