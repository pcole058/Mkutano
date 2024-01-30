module.exports = {
    apps: [
      {
        name: 'decidim',
        cwd: '/home/decidim/app',
        script: 'bundle',
        args: 'exec puma',
        interpreter: 'ruby',
      },
      {
        name: 'sidekiq',
        cwd: '/home/decidim/app',
        script: 'bundle',
        args: 'exec sidekiq',
        interpreter: 'ruby',
        restart_delay: 30000,
        max_memory_restart: '700M',
        min_uptime: 20000,
      }
    ],
  };
  