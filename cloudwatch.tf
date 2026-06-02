resource "aws_cloudwatch_log_group" "backend" {
  name              = "/hotel-booking/backend"
  retention_in_days = 7
}
