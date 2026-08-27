# PAXI Wallet Railway extraction-style deployment image
# Upload this Dockerfile together with paxi-wallet-backend-railway-public.zip.
# Secrets are supplied only through Railway environment variables.
FROM node:22-bookworm-slim
WORKDIR /app
RUN apt-get update \
  && apt-get install -y --no-install-recommends unzip \
  && rm -rf /var/lib/apt/lists/*
# The archive intentionally contains one top-level paxi-wallet/ directory.
COPY paxi-wallet-backend-railway-public.zip /tmp/paxi-wallet-backend-railway-public.zip
RUN unzip -q /tmp/paxi-wallet-backend-railway-public.zip -d /tmp/paxi-wallet-src \
  && cp -a /tmp/paxi-wallet-src/paxi-wallet/. /app/ \
  && rm -rf /tmp/paxi-wallet-src /tmp/paxi-wallet-backend-railway-public.zip \
  && npm ci --include=dev --no-audit --no-fund \
  && npm run build
ENV NODE_ENV=production
# Railway supplies PORT at runtime; the application reads process.env.PORT.
EXPOSE 3000
CMD ["npm", "run", "start"]
