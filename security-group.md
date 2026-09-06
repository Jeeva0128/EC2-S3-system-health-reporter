# Security Group Configuration

## Security Group

Name: EC2HealthReporterSG-Hyderabad

## Inbound Rules

| Type | Protocol | Port | Source |
|---|---|---:|---|
| SSH | TCP | 22 | EC2 Instance Connect prefix list |

## Outbound Rules

Allow all outbound traffic.

## Security Design

- SSH access is restricted to the AWS-managed EC2 Instance Connect prefix list.
- No HTTP or HTTPS inbound access is required.
- No SSH access is open to `0.0.0.0/0`.
- The EC2 instance uses an IAM role instead of hardcoded AWS credentials.

