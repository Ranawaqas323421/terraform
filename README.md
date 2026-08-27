# Terraform EC2 Deployment

Terraform config to create an EC2 instance in the default VPC with an SSH key pair and security group (SSH + HTTP access).

## Prerequisites

- Terraform installed
- AWS CLI configured (`aws configure`)
- SSH key generated: `ssh-keygen -f waqas323`

## Usage

```bash
terraform init
terraform plan
terraform apply
```

Secure the key and connect:
```bash
chmod 400 waqas323
ssh -i waqas323 ec2-user@<instance_public_ip>
```

## Cleanup

```bash
terraform destroy
```

## Notes

- Uses temporary AWS session credentials — refresh in `~/.aws/credentials` if you hit `ExpiredToken`.
- Restrict SSH ingress (`0.0.0.0/0`) to your IP for production use.
