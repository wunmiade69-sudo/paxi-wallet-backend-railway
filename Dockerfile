# PAXI Wallet Railway extraction-style deployment image
# Railway receives this Dockerfile together with paxi-wallet-application.zip.
# Secrets are supplied only through Railway environment variables.

FROM node:22-bookworm-slim

WORKDIR /app

RUN apt-get update \
  && apt-get install -y --no-install-recommends unzip \
  && rm -rf /var/lib/apt/lists/*

# The inner archive intentionally contains one top-level paxi-wallet/ directory.
COPY paxi-wallet-application.zip /tmp/paxi-wallet-application.zip

RUN unzip -q /tmp/paxi-wallet-application.zip -d /tmp/paxi-wallet-src \
  && cp -a /tmp/paxi-wallet-src/paxi-wallet/. /app/ \
  && rm -rf /tmp/paxi-wallet-src /tmp/paxi-wallet-application.zip \
  && npm ci --include=dev --no-audit --no-fund \
  && npm run build

ENV NODE_ENV=production

# Railway supplies PORT at runtime; the application reads process.env.PORT.
EXPOSE 3000

CMD ["npm", "run", "start"]
