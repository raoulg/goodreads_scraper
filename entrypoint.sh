#!/bin/bash
set -euo pipefail

# Start the Lambda RIE with your Lambda handler
exec /usr/local/bin/aws-lambda-rie /usr/local/bin/julia /app/lambda_handler.jl
