resource "aws_autoscaling_group" "asg" {
  name                = "strapi-server-asg"
  vpc_zone_identifier = [data.aws_subnet.private_subnet1.id, data.aws_subnet.private_subnet2.id]
  desired_capacity    = 1
  max_size            = 1
  min_size            = 1
  health_check_type   = "ELB"
  target_group_arns   = [data.aws_lb_target_group.alb_tg.arn]

  launch_template {
    id      = aws_launch_template.lt.id
    version = "$Latest"
  }

  instance_refresh {
    strategy = "Rolling"

    preferences {
      min_healthy_percentage = 90
      max_healthy_percentage = 200
    }
  }
}
