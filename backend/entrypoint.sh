#!/bin/bash
set -euo pipefail

# Start the RIE in the background
/usr/local/bin/aws-lambda-rie >/dev/null 2>&1 &

# Execute the bootstrap script
exec /app/bootstrap