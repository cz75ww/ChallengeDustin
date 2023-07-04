resource "aws_autoscaling_policy" "asp_staging" {
  name                   = "fpsouza-asp-staging"
  scaling_adjustment     = 1
  adjustment_type        = "ChangeInCapacity"
  cooldown               = 300
  autoscaling_group_name = aws_autoscaling_group.asg_staging.name
}

resource "aws_autoscaling_group" "asg_staging" {
  name = "fpsouza-asg-staging"
  vpc_zone_identifier = aws_subnet.private_subnet[*].id
  min_size            = 2
  max_size            = 4
  health_check_type   = "ELB"
  target_group_arns   = [aws_lb_target_group.alb-target-group.arn]

  lifecycle {
    create_before_destroy = true
  }

  launch_template {
    id      = aws_launch_template.fpsouza_lt-staging.id
    version = "$Latest"
  }
  tag {
    key                 = "Name"
    value               = "webserver"
    propagate_at_launch = true
  }
  tag {
    key                 = "Initialized"
    value               = "false"
    propagate_at_launch = true
  }
}