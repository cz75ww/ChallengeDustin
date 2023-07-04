#!/bin/bash
# ===============================================================
# Script Name....: web_health_check.sh
# Server.........: Linux servers
# Function.......: Health Check server & web application status
# Creation Date..: May 19th, 2021
#
# Created by.....: Fabiano Souza
# ================================================================                 

AWSCLI_PROFILE="default"
SNS_TOPIC_ARN="arn:aws:sns:us-east-1:076489258907:NotifyMe"
declare -a SERVER_NAME=$(aws elbv2 describe-load-balancers --query 'LoadBalancers[*].[LoadBalancerName,DNSName,LoadBalancerArn]' --output text | awk '{print $2}')
SUBJECT_PREFIX="Web Application Health Check"
WEB_OK="200"
CHK_WEB_STATUS=$(/usr/bin/curl --write-out %{http_code} --silent --output /dev/null $SERVER_NAME)


if [[ "$CHK_WEB_STATUS" != "200" ]]; then
  echo "Execution started at: ${CHK_WEB_STATUS}"
  /usr/local/bin/aws --profile="${AWSCLI_PROFILE}" sns publish \
  --topic-arn="$SNS_TOPIC_ARN" \
  --message "WEB PAGE ISSUE on webserver $SERVER" \
  --subject "$SUBJECT_PREFIX - WEB PAGE ISSUE "
  echo "WEB PAGE ERROR: ${CHK_WEB_STATUS} on server $SERVER"
  echo "SERVER $SERVER IS NOT RUNNING"
else
  echo "Return Code: $CHK_WEB_STATUS"
fi