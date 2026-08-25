# Railway Dockerfile for the current repository layout.
# The repository contains this Dockerfile and
# paxi-wallet-backend-railway-public.zip at its root.
# Secrets are supplied by Railway environment variables.

FROM node:22-bookworm-slim

WORKDIR /app

RUN apt-get update \
  && apt-get install -y --no-install-recommends unzip \
  && rm -rf /var/lib/apt/lists/*

COPY paxi-wallet-backend-railway-public.zip /tmp/paxi-wallet-backend.zip

# Extract the sanitized project into the application root, install the locked
# dependencies, and run the existing npm build. No migration is executed here.
RUN unzip -q /tmp/paxi-wallet-backend.zip -d /app \
  && rm /tmp/paxi-wallet-backend.zip \
  && npm ci --include=dev \
  && npm run build \
  && npm prune --omit=dev

ENV NODE_ENV=production

# Railway supplies PORT at runtime; the application reads process.env.PORT.
EXPOSE 3000

CMD ["npm", "run", "start"]
