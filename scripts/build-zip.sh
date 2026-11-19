#!/bin/sh
# Rebuild email-countdowns.zip for upload to Claude.ai or ChatGPT.
set -eu
cd "$(dirname "$0")/../skills"
rm -f ../email-countdowns.zip
zip -rq -X ../email-countdowns.zip email-countdowns -x '*.DS_Store'
echo "Built email-countdowns.zip"
