# Hotel Booking Infrastructure

Infrastructure for a hotel booking REST API backend built with Go,
deployed on AWS using Terraform and GitHub Actions.

## Architecture

```
Internet → Route 53 → ALB (HTTPS:443) → EC2 (Docker:8080) → RDS PostgreSQL
```

Supporting services:
- ECR — Docker image registry
- Secrets Manager — database credentials
- CloudWatch — container logs and CPU alarms
- SSM Session Manager — secure deployment without SSH

## Tech Stack

- **Backend**: Go
- **Containerization**: Docker
- **Infrastructure as Code**: Terraform
- **CI/CD**: GitHub Actions
- **Cloud**: AWS
  - VPC — isolated network with public and private subnets
  - EC2 — runs the Docker container
  - ECR — stores Docker images (lifecycle policy retains last 10)
  - RDS — PostgreSQL database in private subnets
  - ALB — HTTPS load balancer
  - ACM — free SSL/TLS certificate with DNS validation
  - Route 53 — DNS management
  - Secrets Manager — database credentials fetched at runtime
  - CloudWatch — container logs and EC2 CPU alarm
  - SSM Session Manager — secure deployment without SSH

## Infrastructure Setup

1. Run `terraform apply` to provision all infrastructure
2. Copy the nameservers from Terraform output and update them in Porkbun
3. Wait for ACM certificate to show Issued
4. Trigger GitHub Actions to deploy the container

## CI/CD Pipeline

Triggered on every push to `master`:

1. Vet, test, and build the Go app
2. Build and push Docker image to ECR
3. Deploy to EC2 via SSM Session Manager (no SSH required)
4. EC2 pulls the latest image, stops the old container, starts the new one
5. EC2 runs the deploy script via SSM — polls `GET /api/health` for up to 60s to confirm the service is up

## HTTPS Flow

- Route 53 resolves the domain to the ALB
- ALB terminates SSL using an ACM certificate
- ALB forwards plain HTTP traffic to EC2 on port 8080
- EC2 runs the Go app inside a Docker container

## Monitoring

- CloudWatch log group `/hotel-booking/backend` with 7-day retention
- CloudWatch alarm triggers SNS email when EC2 CPU exceeds 80%
