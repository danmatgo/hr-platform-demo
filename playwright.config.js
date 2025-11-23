const { defineConfig } = require('@playwright/test');

module.exports = defineConfig({
  testDir: './test/e2e',
  webServer: {
    command: 'bundle exec rails server',
    url: 'http://127.0.0.1:3000',
    reuseExistingServer: !process.env.CI,
  },
  use: {
    baseURL: 'http://120.0.0.1:3000',
    video: 'on-first-retry',
  },
});
