module "staging-project" {
  source                = "../../modules/deploy/"
  vpc_name              = "fpsouza-vpc-staging"
  cidr_vpc              = "10.0.0.0/16"
  public_subnet         = ["10.0.1.0/24", "10.0.2.0/24"]
  private_subnet        = ["10.0.101.0/24", "10.0.102.0/24"]
  public_subnet_name    = ["public-subnet-1", "public-subnet-2", ]
  private_subnet_name   = ["private-subnet-1", "private-subnet-2", ]
  internet_access_name  = "fpsouza-igw"
  public_sg             = "fpsouza-public-sg"
  lb_sg                 = "fpsouza-alb-sg"
  private_sg            = "fpsouza-private-sg"
  ingress_ssh_ports     = [22]
  ingress_lb_ports      = [80, 443]
  ingress_private_ports = [22, 80, 443, 2049]
  ingress_efs_ports     = [2049]
  aws_key_name          = "cz75ww"
  aws_key_path          = "/Users/fpsouza/.ssh/cz75ww.cer"
  ssh_user              = "ubuntu"
  server_tag_name       = "jumpserver"
}