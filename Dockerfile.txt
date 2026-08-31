# PAXI Wallet — Railway two-file deployment
# Push ONLY these two things to the repo root:
#   1) this Dockerfile
#   2) paxi-wallet-backend-railway-public.zip  (filename must match exactly)
# Railway builds this Dockerfile against that repo, and the zip is
# extracted here, inside the image — nothing needs to be unzipped locally.

FROM node:22-bookworm-slim

WORKDIR /app

# The archive contains the complete source with package.json, package-lock.json,
# client/, server/, drizzle/, scripts/, and railway.toml at its archive root.
COPY paxi-wallet-backend-railway-public.zip /tmp/paxi-wallet-backend-railway-public.zip

RUN apt-get update \
    && apt-get install -y --no-install-recommends unzip ca-certificates \
    && unzip -q /tmp/paxi-wallet-backend-railway-public.zip -d /app \
    && rm -rf /var/lib/apt/lists/* /tmp/paxi-wallet-backend-railway-public.zip

# Install the locked dependency tree, including build-time dev dependencies.
RUN npm ci --include=dev --no-audit --no-fund

# Build the existing Vite client and bundled Express server.
RUN npm run build

ENV NODE_ENV=production

# Railway injects PORT at runtime. The application reads process.env.PORT.
EXPOSE 3000

CMD ["npm", "run", "start"]
