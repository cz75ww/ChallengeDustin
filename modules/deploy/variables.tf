#############################################################
#                      NETWORK SET UP                       #
#############################################################
// Variable to set the VPC 
variable "vpc_name" {
  description = "vpc for staging environment"
  type        = string
}

//  Variable to set the CIDR block
variable "cidr_vpc" {
  description = "CIDR for staging VPC"
  type        = string
}
// Variable to set the subnets (private and public)
variable "public_subnet" {
  description = "subnet for staging VPC"
  type        = list(any)
}

variable "private_subnet" {
  description = "subnet for staging VPC"
  type        = list(any)
}

variable "azs" {
  description = "azs for staging environment"
  type        = list(any)
  default     = ["us-east-1a", "us-east-1b"]
}
variable "public_subnet_name" {
  description = "subnet name for staging"
  type        = list(any)
}

variable "private_subnet_name" {
  description = "subnet name for staging"
  type        = list(any)
}

variable "internet_access_name" {
  description = "internet gateway name"
  type        = string
}

#############################################################
#             SECURITY GROUP SET UP                         #
#############################################################

variable "public_sg" {
  description = "security group for internet access"
  type        = string
}

variable "lb_sg" {
  description = "security group for load balancer"
  type        = string
}

variable "private_sg" {
  description = "security group for load balancer"
  type        = string
}

variable "ingress_ssh_ports" {
  description = "ingress for ssh connection for Jump Server"
  type        = list(any)
}
variable "ingress_private_ports" {
  description = "ingress for private sg"
  type        = list(any)
}

variable "ingress_lb_ports" {
  description = "ingress for lb sg"
  type        = list(any)
}

variable "ingress_efs_ports" {
  description = "ingress for efs sg"
  type        = list(any)
}

############################################################
#           APPLICATION LOAD BALANCER SET UP               #
############################################################

variable "health_check" {
  type = map(any)
  default = {
    inputs = {
      timeout             = "30"
      interval            = "60"
      path                = "/"
      port                = "80"
      unhealthy_threshold = "10"
      healthy_threshold   = "10"
    }
  }
}

###########################################################
#             EC2 - JUMPSERVER SET UP                     #
###########################################################
variable "aws_key_name" {
  description = "Key name for AWS environment"
}

variable "aws_key_path" {
  description = "Key path for AWS environment"
}

variable "ssh_user" {
  description = "ssh connection user"
}

variable "server_tag_name" {
  description = "Server tag name on VPC"
}

