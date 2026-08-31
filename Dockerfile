# PAXI Wallet — Railway two-file deployment extractor
# Upload this file together with paxi-wallet-backend-railway-public.zip.
# Secrets are supplied only through Railway environment variables.

FROM node:22-bookworm-slim

WORKDIR /app

# The archive contains the complete source with package.json, package-lock.json,
# client/, server/, drizzle/, scripts/, and Dockerfile at its archive root.
COPY paxi-wallet-backend-railway-public.zip /tmp/paxi-wallet-backend-railway-public.zip

RUN apt-get update \
    && apt-get install -y --no-install-recommends unzip ca-certificates \
    && unzip -q /tmp/paxi-wallet-backend-railway-public.zip -d /app \
    && rm -rf /var/lib/apt/lists/* /tmp/paxi-wallet-backend-railway-public.zip

# Install locked dependencies, including build-time development dependencies.
RUN npm ci --include=dev --no-audit --no-fund

# Build the existing Vite client and bundled Express server.
RUN npm run build

ENV NODE_ENV=production

# Railway supplies PORT at runtime; the application reads process.env.PORT.
EXPOSE 3000

CMD ["npm", "run", "start"]
