// pm2 ecosystem config
// Defines which processes pm2 should run inside the container.
// Docs: https://pm2.keymetrics.io/docs/usage/application-declaration/

module.exports = {
  apps: [
    {
      name: "tool-hub",
      cwd: "/apps/tool-hub",
      script: "npm",
      args: "start",           // change to "run serve" etc. if needed
      env: {
        NODE_ENV: "production",
        PORT: 8135,
      },
      // Restart if the process crashes, but don't loop forever
      autorestart: true,
      max_restarts: 5,
      restart_delay: 3000,
      kill_timeout: 5000
    },
    {
      name: "welcome-tool",
      cwd: "/apps/welcome-tool",
      script: "npm",
      args: "start",
      env: {
        NODE_ENV: "production",
        PORT: 8136,
      },
      autorestart: true,
      max_restarts: 5,
      restart_delay: 3000,
      kill_timeout: 5000
    },
    {
      name: "events-tool",
      cwd: "/apps/events-tool",
      script: "npm",
      args: "start",
      env: {
        NODE_ENV: "production",
        PORT: 8137,
      },
      autorestart: true,
      max_restarts: 5,
      restart_delay: 3000,
      kill_timeout: 5000
    },
    {
      name: "publish-tool",
      cwd: "/apps/publish-tool",
      script: "npm",
      args: "start",
      env: {
        NODE_ENV: "production",
        PORT: 8138,
      },
      autorestart: true,
      max_restarts: 5,
      restart_delay: 3000,
      kill_timeout: 5000
    },
  ],
};