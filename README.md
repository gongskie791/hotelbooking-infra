# Hotel booking Infrastructure

Infrastructure for a hotel booking REST api backend built with GO,
deployed on AWS using Terraform and Github Actions.

## Architecture

Internet -> Route 53 -> (HTTPS:443) -> EC2 (DOCKER:8080) -> RDS PostgresSQL

ECR (Docker Images)
Secrets Manager (DB credentials)
CloudWatch (container logs)

## Tech Stack

- **Backend**: Go
- **Containerization**: Docker
- **Infrastructure as Code**: Terraform
- **CI/CD**: Github Actions
- **Cloud**: AWS
  - EC2 -- runs the Docker container
  - ECR -- stores Docker images
  - RDS -- PostgreSQL database
  - ALB -- HTTPS load balancer
  - ACM -- SSL/TLS certificate
  - Route 53 -- DNS management
  - Secrets Manager -- database credentials
  - CloudWatch -- container logs
  - SSM Session Manager -- secure deployment without SSH
  - VPC -- isolated network

## Infrastructure Setup

1. Run `terraform apply` to provision all infrastructure
2. Copy the nameservers from terraform output and update them in Porkbun
3. Wait for ACM certificate to show Issued
4. Trigger GitHub Actions to deploy the container

## CI/CD Pipeline

On Every push to `main`

1. GitHub Actions builds the Docker image
2. Pushes the image to ECR
3. Deploys to EC2 via SSM Session Manager (no SSH required)
4. Runs the container with environment variables from Secrets Manager
5. Health check verifies the deployment succeeded

## HTTPS Flow

- Route 53 resolves the domain to the ALB
- ALB terminates SSL using an ACM certificate
- ALB forwards plain HTTP traffic to the EC2 on port 8080
- EC2 runs the Go app inside a Docker container
