resource "aws_cloudwatch_metric_alarm" "cpu_high" {
  alarm_name          = "ec2-cpu-high"
  comparison_operator = "GreaterThanThreshold"
  evaluation_periods  = 1
  metric_name         = "CPUUtilization"
  namespace           = "AWS/EC2"
  period              = 300
  statistic           = "Average"
  threshold           = 80
  alarm_description   = "EC2 CPU above 80%"
  alarm_actions       = [aws_sns_topic.ec2_alerts.arn]

  dimensions = {
    InstanceId = aws_instance.backend_instance.id
  }
}

resource "aws_sns_topic" "ec2_alerts" {
  name = "ec2-cpu-alert"
}

resource "aws_sns_topic_subscription" "email" {
  topic_arn = aws_sns_topic.ec2_alerts.arn
  protocol  = "email"
  endpoint  = "markjosephtiempo1@gmail.com"
}
