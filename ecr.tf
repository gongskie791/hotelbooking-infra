resource "aws_ecr_repository" "hotel-booking-backend" {
  name                 = "hotel-booking-backend"
  image_tag_mutability = "MUTABLE"
  force_delete         = true
  image_scanning_configuration {
    scan_on_push = true
  }
}
