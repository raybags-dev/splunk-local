# Use the official Splunk image as base
FROM splunk/splunk:latest

WORKDIR /opt/splunk-local

# Create scripts with proper permissions in one RUN command
RUN echo '#!/bin/bash' > start-splunk.sh && \
    echo 'echo "Starting Splunk..."' >> start-splunk.sh && \
    echo '/sbin/entrypoint.sh splunkd' >> start-splunk.sh && \
    echo '#!/bin/bash' > stop-splunk.sh && \
    echo 'echo "Stopping Splunk..."' >> stop-splunk.sh && \
    echo '/opt/splunk/bin/splunk stop' >> stop-splunk.sh && \
    chmod +x start-splunk.sh stop-splunk.sh

EXPOSE 8000 8089

ENV SPLUNK_START_ARGS=--accept-license
ENV SPLUNK_USERNAME=${SPLUNK_USERNAME}
ENV SPLUNK_PASSWORD=${SPLUNK_PASSWORD}

# Start Splunk automatically
ENTRYPOINT ["/opt/splunk-local/start-splunk.sh"]