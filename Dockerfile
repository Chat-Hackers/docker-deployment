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

ARG VITE_AUTH_LINK
ENV VITE_AUTH_LINK=$VITE_AUTH_LINK

ARG VITE_WRAPPER_URL
ENV VITE_WRAPPER_URL=$VITE_WRAPPER_URL

ARG VITE_TRELLO_KEY
ENV VITE_TRELLO_KEY=$VITE_TRELLO_KEY

# ── Clone repositories ──────────────────

RUN git clone https://github.com/Chat-Hackers/tool-hub.git tool-hub
RUN git clone https://github.com/Chat-Hackers/welcome-tool.git welcome-tool
RUN git clone https://github.com/Chat-Hackers/events-tool.git events-tool
RUN git clone https://github.com/Chat-Hackers/publish-tool.git publish-tool
RUN git clone https://github.com/Chat-Hackers/trello-tool.git trello-tool

# ── Install dependencies for each repo ───────
RUN cd tool-hub && npm ci
RUN cd welcome-tool && npm ci
RUN cd events-tool && npm ci
RUN cd publish-tool && npm ci
RUN cd trello-tool && npm ci

# ── Build web and service for each repo ───────
RUN cd tool-hub && npm run build-web && npm run build
RUN cd welcome-tool && npm run build-web && npm run build
RUN cd events-tool && npm run build-web && npm run build
RUN cd publish-tool && npm run build-web && npm run build
RUN cd trello-tool && npm run build-web && npm run build

# ── Copy the pm2 ecosystem config ────────────
COPY ecosystem.config.js .

# Expose the ports your apps listen on
EXPOSE 8138

# Start all processes via pm2 in foreground mode
# (pm2-runtime keeps pm2 as PID 1, which is correct for Docker)
CMD ["pm2-runtime", "ecosystem.config.js"]
