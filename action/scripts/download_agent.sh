#!/bin/bash

# Immediately exit if any command has a non-zero exit status
set -e

VERSION=$1

# set the repo using env var GITHUB_REPOSITORY or default to bullfrogsec/bullfrog
GITHUB_REPOSITORY=${GITHUB_REPOSITORY:-bullfrogsec/bullfrog}

TMP_DIR="/tmp"
AGENT_FILE_PATH="${TMP_DIR}/agent"
AGENT_FILE="$AGENT_FILE_PATH.tar.gz"
FINAL_BIN_DIR="/opt/bullfrog"

echo "https://github.com/${AGENT_REPO}/releases/download/${VERSION}/agent.tar.gz -o $AGENT_FILE"

if [ -f "$AGENT_FILE" ]; then
    echo "$AGENT_FILE exists."
else
    curl -L https://github.com/${AGENT_REPO}/releases/download/${VERSION}/agent.tar.gz -o "$AGENT_FILE"
fi
tar -xvf "$AGENT_FILE" -C $TMP_DIR

mkdir -p "$FINAL_BIN_DIR"
sudo cp -vRf "$AGENT_FILE_PATH/agent" "$FINAL_BIN_DIR/agent"
sudo rm -rf "$AGENT_FILE_PATH"
