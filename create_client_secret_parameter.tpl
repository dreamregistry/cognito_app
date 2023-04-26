#!/bin/bash

SECRET=$(aws cognito-idp describe-user-pool-client --user-pool-id=${userPoolId} --client-id=${clientId} --query "UserPoolClient.ClientSecret" --output text  --no-cli-pager)

aws ssm put-parameter \
  --name ${parameterKey} \
  --value "$SECRET" \
  --type SecureString \
  --overwrite \
  --no-cli-pager
