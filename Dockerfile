# PAXI Wallet Railway deployment image
# Build and runtime use the existing npm scripts; Railway supplies PORT and secrets.

FROM node:22-bookworm-slim AS app

WORKDIR /app

# Install the locked dependency tree, including build-time dev dependencies.
COPY package.json package-lock.json ./
RUN npm ci --include=dev --no-audit --no-fund

# Build the existing Vite client and bundled Express server.
COPY . .
RUN npm run build

ENV NODE_ENV=production

# Railway injects PORT at runtime. The application reads process.env.PORT.
EXPOSE 3000

CMD ["npm", "run", "start"]
