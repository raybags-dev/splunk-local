#!/bin/bash

CONTAINER_NAME="splunk"
SPLUNK_PORT="8001"
SPLUNK_URL="http://localhost:$SPLUNK_PORT"

if [ -z "$SPLUNK_USERNAME" ] || [ -z "$SPLUNK_PASSWORD" ]; then
    echo "❌ SPLUNK_USERNAME or SPLUNK_PASSWORD not set. Please set them as environment variables."
    exit 1
fi

if [ "$(docker ps -q -f name=$CONTAINER_NAME)" ]; then
    echo "⚠️ Splunk is already running!"
else
    echo "🚀 Starting Splunk container with provided credentials..."

    docker run -d \
        --name $CONTAINER_NAME \
        -p $SPLUNK_PORT:8000 \
        -p 8089:8089 \
        -e SPLUNK_START_ARGS="--accept-license" \
        -e SPLUNK_USERNAME="$SPLUNK_USERNAME" \
        -e SPLUNK_PASSWORD="$SPLUNK_PASSWORD" \
        tonnybags/splunk-local:latest

    echo "⏳ Waiting for Splunk to become ready..."

    until curl -s --head --fail $SPLUNK_URL > /dev/null; do
        echo "   ... still waiting ..."
        sleep 5
    done

    echo "✅ Splunk is up and running!"
fi

# Open web UI automatically
if command -v xdg-open &> /dev/null; then
    xdg-open $SPLUNK_URL
elif command -v open &> /dev/null; then
    open $SPLUNK_URL
elif command -v explorer.exe &> /dev/null; then
    explorer.exe "$SPLUNK_URL"
else
    echo "> Open $SPLUNK_URL manually in your browser."
fi
