FROM node:alpine

# Set working directory
WORKDIR /app

# Install n8n globally, rclone, redis, and postgresql
RUN npm install -g n8n && \
    apk add --no-cache rclone redis postgresql postgresql-contrib

# Create data directories and set permissions
RUN mkdir -p /home/node/.n8n /home/node/.config/rclone /home/node/redis-data /home/node/pgdata && \
    chown -R node:node /home/node

# Copy startup script
COPY startup.sh startup.sh
RUN chmod +x startup.sh

# Ensure /run/postgresql exists and is writable by node
RUN mkdir -p /run/postgresql && chmod 775 /run/postgresql && chown node:node /run/postgresql

# Switch to node user
USER node

# Set environment variables
ENV N8N_PORT=5678
ENV N8N_RUNNERS_ENABLED=true
ENV N8N_ENFORCE_SETTINGS_FILE_PERMISSIONS=true

ENV N8N_HOST=loko99-n8n.hf.space
ENV N8N_PROTOCOL=https
ENV WEBHOOK_URL=https://loko99-n8n.hf.space

# PostgreSQL environment variables (can be overridden)
ENV POSTGRES_USER=node
ENV POSTGRES_PASSWORD=changeme
ENV POSTGRES_DB=n8n
ENV POSTGRES_PORT=5432

# Expose ports for n8n, redis, and postgresql
EXPOSE 5678
EXPOSE 6379
EXPOSE 5432

# Start with backup script
CMD sh startup.sh