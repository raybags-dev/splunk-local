# Use the official Splunk image as base
FROM splunk/splunk:latest

WORKDIR /opt/splunk-local

COPY start-splunk.sh stop-splunk.sh ./

RUN chmod +x ./start-splunk.sh ./stop-splunk.sh

EXPOSE 8000 8089

ENV SPLUNK_START_ARGS=--accept-license
ENV SPLUNK_USERNAME=${SPLUNK_USERNAME}
ENV SPLUNK_PASSWORD=${SPLUNK_PASSWORD}

# Start Splunk automatically
ENTRYPOINT ["/opt/splunk-local/start-splunk.sh"]
