shall i delete these 

I checked all four files. They look good, but I spotted one unwanted file:

"README.md'"

That's a separate file caused by an accidental quote in the filename. We should remove it before GitHub.

Run:

rm "README.md'"

Then verify:

ls -l

You should have exactly:

README.md
health-report.sh
iam-policy.json
lifecycle.json
security-group.md
One other important correction

Your iam-policy.json is intentionally very restrictive, which is good. However, your README currently says:

"The role is restricted to uploading objects to health-reports/*"

That's accurate.

And your lifecycle.json correctly matches the 30-day rule.

So don't change those files.

After removing README.md', run:

git status

You'll probably see that this isn't a Git repository yet. That's expected.

Then we'll initialize Git and make your first clean commit.

I can see the GitHub repo and your terminal. 👍 The code/config files are pushed successfully, and main is up to date.

But there is one important issue:

⚠️ README is not on GitHub

Your GitHub page shows only:

health-report.sh
iam-policy.json
lifecycle.json
security-group.md

There is no README.md displayed, even though you created it locally.

Your terminal also shows the first commit contained only 4 files, which explains why the README wasn't included.

Let's diagnose this before doing anything else.

Run these two commands:

git ls-files

and:

git check-ignore -v README.md

Send me the output. Don't modify or commit anything yet. We'll figure out why Git isn't tracking the README.

i have deleted readme but its okay i can create  in github now give me the content

Yes, that's completely fine. You can create the README directly on GitHub. Since your repo already has the other four files, use this as the final README.

Copy everything below into GitHub's README.md editor:

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
One thing I'd change on GitHub

For the repository About/Description, use:

Automated EC2 system health reports archived to Amazon S3 using IAM roles and cron.

And add topics such as:

aws
ec2
s3
iam
bash
linux
cron
aws-cli
cloud-engineering

Once you create the README, your repository will have all 5 project files and be ready for the final review.
