# SkyHigh Portfolio Project 02 — AWS Infrastructure with Terraform

## Project Overview

This project demonstrates how to use Terraform to deploy a multi-tier AWS infrastructure using Infrastructure as Code (IaC).

The environment includes a custom VPC with public and private subnets across two Availability Zones, an Internet Gateway, a NAT Gateway, route tables, security groups, an EC2 web server, and a private S3 bucket.

The VPC infrastructure is organized as a reusable Terraform module, while the remaining resources are managed from the root configuration.
## Architecture

The infrastructure uses a multi-tier network design in the `us-east-1` AWS Region.

- **VPC:** `10.0.0.0/16`
- **Public Subnet 1:** `10.0.1.0/24` in `us-east-1a`
- **Public Subnet 2:** `10.0.2.0/24` in `us-east-1b`
- **Private Subnet 1:** `10.0.3.0/24` in `us-east-1a`
- **Private Subnet 2:** `10.0.4.0/24` in `us-east-1b`
- **Internet Gateway:** Provides internet access for resources in the public subnets.
- **NAT Gateway:** Allows resources in the private subnets to initiate outbound internet connections.
- **EC2 Web Server:** Runs Nginx in the first public subnet.
- **S3 Bucket:** Private bucket with versioning enabled and public access blocked.
- **Web Security Group:** Allows HTTP on port 80 from the internet and SSH on port 22 only from an approved IP address.
- **Database Security Group:** Allows PostgreSQL traffic on port 5432 only from resources using the Web Security Group.
## Project Structure

```text
skyhigh-portfolio-project-02/
├── main.tf
├── variables.tf
├── outputs.tf
├── security.tf
├── compute.tf
├── storage.tf
├── terraform.tfvars
├── .gitignore
├── README.md
└── modules/
    └── vpc/
        ├── main.tf
        ├── variables.tf
        └── outputs.tf
```

The root configuration manages the project-specific resources such as EC2, S3, and security groups. The `modules/vpc/` directory contains the reusable networking configuration for the VPC, subnets, Internet Gateway, NAT Gateway, and route tables.
## Technologies Used

- **Terraform** — Used to define and provision the AWS infrastructure as code.
- **AWS VPC** — Provides an isolated network for the project resources.
- **Amazon EC2** — Hosts the Nginx web server.
- **Amazon S3** — Provides private object storage with versioning enabled.
- **AWS Security Groups** — Control inbound and outbound network traffic.
- **NAT Gateway** — Provides outbound internet access for resources in private subnets.
- **Internet Gateway** — Provides internet connectivity for resources in public subnets.

## Why Use a Terraform Module?

The VPC was created as a reusable Terraform module to keep the networking configuration organized and separate from the project-specific resources. Using modules makes Terraform configurations easier to maintain, reuse, and scale as infrastructure becomes more complex.
## Deployment Steps

1. Clone the repository and navigate to the project directory.

2. Initialize Terraform:

```bash
terraform init
```

3. Format the Terraform configuration:

```bash
terraform fmt -recursive
```

4. Validate the configuration:

```bash
terraform validate
```

5. Review the infrastructure Terraform will create:

```bash
terraform plan
```

6. Deploy the infrastructure:

```bash
terraform apply
```

7. Enter `yes` when prompted to approve the deployment.

After deployment, Terraform displays outputs for the VPC ID, public subnet IDs, private subnet IDs, EC2 public IP address, and S3 bucket name.
## Verification

After deployment, the infrastructure was verified using Terraform, the AWS Management Console, and a web browser.

- Terraform successfully displayed the required outputs, including the VPC ID, public and private subnet IDs, EC2 public IP address, and S3 bucket name.
- The AWS VPC console confirmed that two public subnets and two private subnets were successfully created.
- The EC2 instance successfully launched in a public subnet.
- Nginx was automatically installed and started using Terraform user data.
- Navigating to the EC2 instance's public IP address displayed the message:

> **Hello from Terraform!**

This confirmed that the EC2 instance was reachable over HTTP and that the automated web server configuration completed successfully.
## Cleanup

After verifying the infrastructure and capturing the required screenshots, all AWS resources were removed using Terraform to prevent unnecessary charges.

```bash
terraform destroy
```

After reviewing the destruction plan, `yes` was entered to confirm the cleanup.

Terraform successfully removed all 20 managed resources:

```text
Destroy complete! Resources: 20 destroyed.
```

Destroying the infrastructure after testing was especially important because resources such as the NAT Gateway can continue generating AWS charges while they remain active.
## Challenges and Lessons Learned

During this project, I encountered and resolved several real-world infrastructure issues:

- **IAM Permissions:** The initial deployment failed because the IAM user did not have permission to create VPC resources. After reviewing the error message and updating the required permissions, Terraform was able to provision the networking infrastructure.
- **EC2 Instance Type:** The project originally specified `t2.micro`, but AWS reported that it was not Free Tier eligible for the account. I used the AWS CLI to identify eligible instance types and changed the configuration to `t3.micro`, which was compatible with the Amazon Linux 2023 x86_64 AMI.
- **Terraform Modules:** I gained experience separating networking resources into a reusable VPC module and passing values between the module and root configuration using variables and outputs.
- **Resource Dependencies:** I learned how resources such as subnets, route tables, an Internet Gateway, a NAT Gateway, security groups, and EC2 instances depend on one another when building a complete AWS environment.
- **Cost Management:** I learned the importance of destroying temporary cloud infrastructure after testing, particularly resources such as NAT Gateways that can continue generating charges.

This project strengthened my understanding of Infrastructure as Code, Terraform modules, AWS networking, security groups, automated EC2 configuration, troubleshooting, and cloud resource lifecycle management.