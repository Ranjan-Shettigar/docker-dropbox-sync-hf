FROM alpine:latest

# Install ca-certificates for HTTPS and unzip for extracting PocketBase
RUN apk add --no-cache ca-certificates unzip

# Download and install PocketBase (latest version)
RUN apk add --no-cache curl jq \
    && LATEST_VERSION=$(curl -s https://api.github.com/repos/pocketbase/pocketbase/releases/latest | jq -r '.tag_name') \
    && wget -O /tmp/pocketbase.zip "https://github.com/pocketbase/pocketbase/releases/download/${LATEST_VERSION}/pocketbase_${LATEST_VERSION#v}_linux_amd64.zip" \
    && unzip /tmp/pocketbase.zip -d /usr/local/bin/ \
    && chmod +x /usr/local/bin/pocketbase \
    && rm /tmp/pocketbase.zip \
    && apk add --no-cache rclone
# Copy startup script to /pb_data
COPY startup.sh /pb_data/startup.sh
RUN chmod +x /pb_data/startup.sh

# Create data directory with proper permissions
RUN mkdir -p /pb_data && chmod 755 /pb_data

# Create non-root user with home directory
RUN adduser -D -s /bin/sh -h /home/pocketbase pocketbase

# Change ownership of data directory
RUN chown -R pocketbase:pocketbase /pb_data

# Switch to non-root user
USER pocketbase

# Expose port
EXPOSE 8090

# Set working directory
WORKDIR /pb_data

# Start with backup script
CMD sh startup.sh