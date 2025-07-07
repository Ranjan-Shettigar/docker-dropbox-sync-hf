FROM node:22-alpine

# Set working directory
WORKDIR /app

# Install n8n globally and rclone
RUN npm install -g n8n && \
    apk add --no-cache rclone

# Create data directory and set permissions
RUN mkdir -p /home/node/.n8n /home/node/.config/rclone && \
    chown -R node:node /home/node

# Copy startup script
COPY startup.sh startup.sh
RUN chmod +x startup.sh

# Switch to node user
USER node

# Set environment variables
ENV N8N_PORT=5678
ENV N8N_RUNNERS_ENABLED=true
ENV N8N_ENFORCE_SETTINGS_FILE_PERMISSIONS=true

# Expose port
EXPOSE 5678


# Start with backup script
CMD sh startup.sh