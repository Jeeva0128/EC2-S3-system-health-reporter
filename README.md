# EC2 System Health Reporter → S3 Archive

## Overview

This project automates system health monitoring on an Amazon EC2 instance.

A Bash script collects basic system health information, generates a timestamped report, and uploads the report to an Amazon S3 bucket.

The script is scheduled to run automatically every hour using cron.

## Architecture

```text
User
 |
 | SSH / EC2 Instance Connect
 v
Amazon EC2
 |
 | IAM Role
 v
Amazon S3
 |
 v
health-reports/
```

## AWS Resources

### Amazon EC2

- Instance name: `EC2-Health-Reporter`
- Instance type: `t3.micro`
- Operating system: Amazon Linux 2023
- Region: Asia Pacific (Hyderabad)
- Storage: 8 GiB gp3
- Metadata: IMDSv2 required

### Amazon S3

- Bucket: `jeevanandan-ec2-health-reports-2026`
- Region: Asia Pacific (Hyderabad)
- Object prefix: `health-reports/`
- Object ownership: Bucket owner enforced
- Block Public Access: Enabled
- Default encryption: SSE-S3
- Versioning: Disabled

### IAM

The EC2 instance uses the IAM role `EC2HealthReporterRole`.

The role is restricted to uploading objects to:

`health-reports/*`

The project does not store AWS access keys inside the script.

### Security Group

SSH access uses the AWS-managed EC2 Instance Connect prefix list.

No public HTTP or HTTPS access is required.

### Lifecycle Policy

Objects under:

`health-reports/`

are automatically expired after **30 days**.

## How It Works

1. Cron triggers `health-report.sh` every hour.
2. The script generates a timestamp using the current system time.
3. System health information is collected using Linux commands.
4. A timestamped text report is created.
5. AWS CLI uploads the report to the S3 `health-reports/` prefix.
6. The IAM role attached to EC2 authorizes the S3 upload.
7. S3 lifecycle management automatically expires reports after 30 days.

## Health Information Collected

The script collects:

- Disk usage using `df`
- Memory usage using `free`
- System uptime using `uptime`
- Logged-in users using `who`

## Cron Schedule

The script is scheduled using:

```text
0 * * * * /home/ec2-user/health-report.sh
```

This runs the health reporter at the beginning of every hour while the EC2 instance is running.

## Technologies Used

- AWS EC2
- Amazon S3
- AWS IAM
- AWS CLI
- Linux
- Bash
- Cron

## Security & Cost Considerations

- The EC2 instance uses an IAM role instead of hardcoded AWS credentials.
- The IAM role follows least-privilege access by allowing only `s3:PutObject` for the required S3 prefix.
- S3 Block Public Access is enabled.
- S3 bucket ACLs are disabled.
- SSH access is restricted through EC2 Instance Connect.
- No HTTP or HTTPS inbound access is required.
- S3 lifecycle management limits report retention to 30 days.
- The EC2 instance can be stopped when the project is not being demonstrated to reduce compute usage.

## Project Files

- `health-report.sh` — Bash system health collection and S3 upload script
- `iam-policy.json` — IAM permissions used by the EC2 role
- `lifecycle.json` — S3 lifecycle configuration
- `security-group.md` — Security group configuration

## Project Outcome

The project demonstrates a practical AWS automation workflow using EC2, IAM, S3, Bash, AWS CLI, and cron.

It provides automated system health reporting while applying basic cloud security, access control, and storage lifecycle management.
