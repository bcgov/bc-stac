
# Deploy using Caddy to host static files
FROM caddy:2.9.1-alpine
RUN apk add --no-cache ca-certificates

#Copy Caddy files
COPY Caddyfile /etc/caddy/Caddyfile
RUN caddy fmt --overwrite /etc/caddy/Caddyfile

# Boilerplate, not used in OpenShift/Kubernetes
EXPOSE 8082 3001
# HEALTHCHECK --interval=30s --timeout=6s CMD curl -f http://localhost:3001/health

# Nonroot user
USER 1001