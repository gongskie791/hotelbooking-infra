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
  - EC2 -- runs the dcoker container
  - ECR -- stores Docker images
  - RDS -- PostgresSQL database
  - ALB -- HTTPS load balancer
  - ACM -- SSL/TLS certificate
  - ROUTE 53 -- DNS management
  - Secrets Manager -- database credentials
  - CloudWatch -- container logs
  - VPC -- isolated network

## Infrastructure Setup

1. Run `terraform apply` to provision VPC, EC2, ECR, IAM, Secrets Manager, CloudWatch
2. Create ACM certificate for the domain (DNS validate via Route 53)
3. Create ALB with HTTPS listener and target group pointing to EC2 port 8080
4. Create Route 53 A record aliasing the domain to the ALB

## CI/CD Pipeline

On Every push to `main`

1. Github Actions builds the Docker image
2. Pushes the image to ECR
3. SSHs into EC2 and pulls the latest image
4. Runs the Container with the environment variables from Secrets Manger

## HTTPS Flow

- Route 53 resolves the domain to the ALB
- ALB terminates SSL using an ACM certificate
- ALB forwards plain http traffic to the EC2 on port 8080
- EC2 runs the Go app inside a Docker container
