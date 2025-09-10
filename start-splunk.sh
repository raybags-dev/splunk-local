#!/bin/bash

CONTAINER_NAME="splunk"
SPLUNK_PORT="8001"  # Changed from 8000 to 8001
SPLUNK_URL="http://localhost:$SPLUNK_PORT"

# Check if container is already running
if [ "$(docker ps -q -f name=$CONTAINER_NAME)" ]; then
    echo "⚠️ Splunk is already running!"
else
    echo "🚀 Starting Splunk..."
    # Make sure your docker-compose.yml maps to port 8001
    docker compose up -d

    echo "⏳ Waiting for Splunk container to be healthy..."

    # Poll until Splunk responds
    until curl -s --head --fail $SPLUNK_URL > /dev/null; do
        echo "   ... still waiting ..."
        sleep 5
    done
    echo "✅ Splunk is up and running!"
fi

# Open Splunk in browser
if command -v xdg-open &> /dev/null; then
    xdg-open $SPLUNK_URL
elif command -v open &> /dev/null; then
    open $SPLUNK_URL
elif command -v explorer.exe &> /dev/null; then
    explorer.exe "$SPLUNK_URL"
else
    echo "👉 Open $SPLUNK_URL manually in your browser."
fi