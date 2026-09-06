# EC2 System Health Reporter → S3 Archive

Automated system health reporting on Amazon EC2 with timestamped reports archived to Amazon S3.

## Project Overview

This project uses a Bash script running on an Amazon EC2 instance to collect basic system health information and upload the results to Amazon S3.

The script is executed automatically every hour using cron.

The project demonstrates practical cloud engineering concepts including:

- EC2 compute
- Linux administration
- Bash scripting
- AWS CLI
- IAM roles
- S3 object storage
- Cron automation
- Security groups
- S3 lifecycle management

## Architecture

```text
                    SSH / EC2 Instance Connect
User  ---------------------------------------------->  EC2
                                                        |
                                                        | IAM Role
                                                        | s3:PutObject
                                                        v
                                                   Amazon S3
                                                        |
                                                        v
                                                 health-reports/
```

## Workflow

```text
Cron
  |
  v
health-report.sh
  |
  +--> Disk usage
  |
  +--> Memory usage
  |
  +--> System uptime
  |
  +--> Logged-in users
  |
  v
Timestamped report
  |
  v
AWS CLI
  |
  v
Amazon S3
```

## AWS Infrastructure

### EC2

| Configuration | Value |
|---|---|
| Instance | `EC2-Health-Reporter` |
| Instance Type | `t3.micro` |
| OS | Amazon Linux 2023 |
| Region | Asia Pacific (Hyderabad) |
| Storage | 8 GiB gp3 |
| Metadata | IMDSv2 required |

### S3

| Configuration | Value |
|---|---|
| Bucket | `jeevanandan-ec2-health-reports-2026` |
| Region | Asia Pacific (Hyderabad) |
| Prefix | `health-reports/` |
| Encryption | SSE-S3 |
| Object Ownership | Bucket owner enforced |
| Block Public Access | Enabled |
| Versioning | Disabled |

## IAM Security

The EC2 instance uses the IAM role:

`EC2HealthReporterRole`

The role follows the principle of least privilege and only allows:

```text
s3:PutObject
```

for objects under:

```text
health-reports/*
```

No AWS access keys are stored in the Bash script.

The policy used by the project is available in:

`iam-policy.json`

## Health Report

Each report contains:

- Timestamp
- Root filesystem disk usage
- Memory usage
- System uptime
- Currently logged-in users

Example report filename:

```text
health-report-YYYY-MM-DD_HH-MM-SS.txt
```

## Automation

Cron executes the script at the beginning of every hour:

```text
0 * * * * /home/ec2-user/health-report.sh
```

The job runs only while the EC2 instance is running.

## S3 Lifecycle Management

Health reports are stored under:

```text
health-reports/
```

A lifecycle rule automatically expires objects after **30 days**.

The lifecycle configuration is documented in:

`lifecycle.json`

## Network Security

The EC2 security group allows:

- SSH on TCP port 22 through the AWS-managed EC2 Instance Connect prefix list

The security group does not expose:

- HTTP port 80
- HTTPS port 443
- SSH to `0.0.0.0/0`

The final configuration is documented in:

`security-group.md`

## Project Files

```text
ec2-system-health-reporter/
├── README.md
├── health-report.sh
├── iam-policy.json
├── lifecycle.json
└── security-group.md
```

### File Descriptions

**`health-report.sh`**

Collects system information, generates a timestamped report, and uploads it to S3.

**`iam-policy.json`**

Contains the least-privilege S3 upload policy used by the EC2 IAM role.

**`lifecycle.json`**

Documents the 30-day S3 object expiration policy.

**`security-group.md`**

Documents the EC2 network access configuration.

## Technologies

- Amazon EC2
- Amazon S3
- AWS IAM
- AWS CLI
- Amazon Linux
- Bash
- Cron

## Security Practices

This project intentionally avoids hardcoded AWS credentials.

Security controls include:

- IAM role-based authentication
- Least-privilege S3 permissions
- S3 Block Public Access
- S3 default encryption
- IMDSv2
- Restricted SSH access
- No unnecessary inbound ports
- S3 lifecycle-based retention

## Cost Considerations

The EC2 instance can be stopped when it is not being used for development or demonstration.

Stopping the instance prevents the hourly cron job from executing until the instance is started again.

The S3 lifecycle policy also prevents old health reports from accumulating indefinitely.

## Project Result

The final system provides an automated workflow for collecting EC2 health information and archiving the results in S3.

It combines Linux automation with AWS infrastructure and demonstrates practical use of IAM, EC2, S3, AWS CLI, cron, security groups, and lifecycle policies.
