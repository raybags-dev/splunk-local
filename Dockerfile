# Use the official Splunk image as base
FROM splunk/splunk:latest

# Set working directory
WORKDIR /opt/splunk-local

# Copy your start/stop scripts
COPY start-splunk.sh stop-splunk.sh ./

# Make scripts executable
RUN chmod +x start-splunk.sh stop-splunk.sh

# Expose Splunk Web and Management ports
EXPOSE 8000 8089

# Accept license automatically
ENV SPLUNK_START_ARGS=--accept-license

# Set username/password via environment variables (to be provided at runtime)
ENV SPLUNK_USERNAME=${SPLUNK_USERNAME}
ENV SPLUNK_PASSWORD=${SPLUNK_PASSWORD}

# Start Splunk automatically
ENTRYPOINT ["/opt/splunk-local/start-splunk.sh"]
