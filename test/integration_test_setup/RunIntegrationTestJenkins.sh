#!/bin/bash
set -e

INSTANCE_RUNNING="$NODE_NAME-$EXECUTOR_NUMBER";

cat <<EOT > ./test/integration_test_setup/.env
ACCOUNT_SID=$ACCOUNT_SID
AUTH_TOKEN=$AUTH_TOKEN
ENV=$ENV
REGION=$REGION
EDGE=$EDGE
WORKSPACE_FRIENDLY_NAME=$WORKSPACE_FRIENDLY_NAME
SIGNING_KEY_SID=$SIGNING_KEY_SID
SIGNING_KEY_SECRET=$SIGNING_KEY_SECRET
WHATS_APP_AGENT_NUMBER=$WHATS_APP_AGENT_NUMBER
WHATS_APP_CUSTOMER_NUMBER=$WHATS_APP_CUSTOMER_NUMBER
DD_API_KEY=$DD_API_KEY
JOB_NAME=$(echo $JOB_NAME | cut -d '/' -f1)
BUILD_NUMBER=$BUILD_NUMBER
RUN_SIX_SIGMA_SUITE=$RUN_SIX_SIGMA_SUITE
EOT

sh ./test/integration_test_setup/RunIntegrationTestDocker.sh $INSTANCE_RUNNING || EXIT_CODE=$?

echo "Docker script exit code $EXIT_CODE"

# If tests failed, fail the job
if [[ $EXIT_CODE -ne 0 ]]; then
  echo "Test run failed in Jenkins"
  exit 1
fi
