FROM n8nio/n8n:latest

# Render needs the app to listen on 0.0.0.0 and the port Render expects (default 5678)
ENV N8N_HOST=0.0.0.0
ENV N8N_PORT=5678
ENV N8N_PROTOCOL=http
ENV GENERIC_TIMEZONE=Asia/Bangkok
ENV N8N_SECURE_COOKIE=false

# n8n listens on 5678 by default; Render maps this automatically.
EXPOSE 5678