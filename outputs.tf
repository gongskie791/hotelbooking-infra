output "instances" {
  description = "My instance public IP"
  value       = aws_instance.backend_instance.public_ip
}

output "security_group_id" {
  description = "Security group ID"
  value       = aws_security_group.backend_sg.id
}

output "rds_endpoint" {
  value = aws_db_instance.hotel_booking_db.address
}

output "ecr_registry" {
  value = "${data.aws_caller_identity.current.account_id}.dkr.ecr.${var.region}.amazonaws.com"
}

output "ecr_repository" {
  value = aws_ecr_repository.hotel-booking-backend.name
}

output "ecr_repository_url" {
  value = aws_ecr_repository.hotel-booking-backend.repository_url
}

output "nameservers" {
  description = "Route 53 nameservers - update these in Porkbun"
  value       = aws_route53_zone.main.name_servers
}
