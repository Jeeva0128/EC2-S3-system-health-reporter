#!/bin/bash

TIMESTAMP=$(date '+%Y-%m-%d_%H-%M-%S')

DISK_USAGE=$(df -h /)
MEMORY_USAGE=$(free -h)
UPTIME=$(uptime)
LOGGED_USERS=$(who)

REPORT_FILE="health-report-$TIMESTAMP.txt"

{
echo "========================================"
echo "       EC2 SYSTEM HEALTH REPORT"
echo "========================================"

echo "Timestamp: $TIMESTAMP"

echo
echo "--- Disk Usage ---"
echo "$DISK_USAGE"

echo
echo "--- Memory Usage ---"
echo "$MEMORY_USAGE"

echo
echo "--- Uptime ---"
echo "$UPTIME"

echo
echo "--- Logged-in Users ---"
echo "$LOGGED_USERS"

echo "========================================"
} > "$REPORT_FILE"

aws s3 cp "$REPORT_FILE" s3://jeevanandan-ec2-health-reports-2026/health-reports/
