# ─────────────────────────────────────────────
# Multi-repo Node.js container managed by pm2
# ─────────────────────────────────────────────
FROM node:26-slim

# Install git (needed to clone) and pm2 globally
RUN apt-get update && apt-get install -y --no-install-recommends git bash ca-certificates curl \
    && npm install -g pm2 \
    && rm -rf /var/lib/apt/lists/*

WORKDIR /apps

ARG VITE_BASE_URL
ENV VITE_BASE_URL=$VITE_BASE_URL

# ── Clone your repositories ──────────────────
# Replace the URLs and folder names to match your repos.
# For private repos via SSH, see the SSH note at the bottom of this file.

RUN git clone https://github.com/King-Mob/chathackers-wrapper.git chathackers-wrapper
RUN git clone https://github.com/King-Mob/welcome-tool.git welcome-tool
RUN git clone https://github.com/King-Mob/example-chathackers-module.git example-tool
RUN git clone https://github.com/King-Mob/rainbows-chathackers-tool.git rainbow-tool

# ── Install dependencies for each repo ───────
RUN cd chathackers-wrapper && npm ci
RUN cd welcome-tool && npm ci
RUN cd example-tool && npm ci
RUN cd rainbow-tool && npm ci

# ── Build web and service for each repo ───────
RUN cd chathackers-wrapper && npm run build-web && npm run build
RUN cd welcome-tool && npm run build-web && npm run build
RUN cd example-tool && npm run build-web && npm run build
RUN cd rainbow-tool && npm run build-web && npm run build

# ── Copy the pm2 ecosystem config ────────────
COPY ecosystem.config.js .

# Expose the ports your apps listen on
EXPOSE 8138

# Start all processes via pm2 in foreground mode
# (pm2-runtime keeps pm2 as PID 1, which is correct for Docker)
CMD ["pm2-runtime", "ecosystem.config.js"]
