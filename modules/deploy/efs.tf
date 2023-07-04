# Creating EFS file system
resource "aws_efs_file_system" "efs" {
creation_token = "staging-efs"
tags = {
Name = "staging-efs"
  }
}
# Creating Mount target of EFS
resource "aws_efs_mount_target" "mount" {
count           = length(var.private_subnet) 
file_system_id  = aws_efs_file_system.efs.id
subnet_id       = aws_subnet.private_subnet[count.index].id
security_groups = [aws_security_group.private_sg.id]
}