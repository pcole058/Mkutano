require "#{Rails.root}/lib/decidim/logger_proxy"
require "active_support/logger"

Rails.application.configure do
  
  def env_enabled?(env_name, default_value = "disabled")
    ["true", "1", "enabled"].include? ENV.fetch(env_name, default_value)
  end
  # Settings specified here will take precedence over those in config/application.rb.

  # Code is not reloaded between requests.
  config.cache_classes = true

  # Eager load code on boot. This eager loads most of Rails and
  # your application in memory, allowing both threaded web servers
  # and those relying on copy on write to perform better.
  # Rake tasks automatically ignore this option for performance.
  config.eager_load = true

  # Full error reports are disabled and caching is turned on.
  config.consider_all_requests_local       = false
  config.action_controller.perform_caching = true

  # Ensures that a master key has been made available in either ENV["RAILS_MASTER_KEY"]
  # or in config/master.key. This key is used to decrypt credentials (and other encrypted files).
  # config.require_master_key = true

  # Disable serving static files from the `/public` folder by default since
  # Apache or NGINX already handles this.
  config.public_file_server.enabled = env_enabled?("RAILS_SERVE_STATIC_FILES")


  # `config.assets.precompile` and `config.assets.version` have moved to config/initializers/assets.rb

  # Enable serving of images, stylesheets, and JavaScripts from an asset server.
  # config.action_controller.asset_host = 'http://assets.example.com'

  # Specifies the header that your server uses for sending files.
  # config.action_dispatch.x_sendfile_header = 'X-Sendfile' # for Apache
  # config.action_dispatch.x_sendfile_header = 'X-Accel-Redirect' # for NGINX

  # Store uploaded files on the local file system (see config/storage.yml for options)
  config.active_storage.service = :local

  # Mount Action Cable outside main process or domain
  # config.action_cable.mount_path = nil
  # config.action_cable.url = 'wss://example.com/cable'
  # config.action_cable.allowed_request_origins = [ 'http://example.com', /http:\/\/example.*/ ]

  # Force all access to the app over SSL, use Strict-Transport-Security, and use secure cookies.
  config.force_ssl = env_enabled?("RAILS_FORCE_SSL")

  # Use the lowest log level to ensure availability of diagnostic information
  # when problems arise.
  config.log_level = ENV.fetch("DECIDIM_LOG_LEVEL", "info").to_sym

  # Prepend all log lines with the following tags.
  config.log_tags = [ :request_id ]

  # Use a different cache store in production.
  if ENV.fetch("RAILS_CACHE_MODE", "disabled") == "redis" && ENV["CACHE_REDIS_URL"].present?
    config.cache_store = :redis_cache_store, { url: ENV.fetch("CACHE_REDIS_URL") }
  end

  if ENV.fetch("RAILS_CACHE_MODE", "disabled") == "memcached"
    config.cache_store = :mem_cache_store, ENV.fetch("MEMCACHED_SERVERS", "localhost")
  end

  # Use a real queuing backend for Active Job (and separate queues per environment)
  if ENV.fetch("RAILS_JOB_MODE", "default") == "sidekiq"
    config.active_job.queue_adapter = :sidekiq
  end

  config.action_mailer.perform_caching = false

  # Ignore bad email addresses and do not raise email delivery errors.
  # Set this to true and configure the email server for immediate delivery to raise delivery errors.
  # config.action_mailer.raise_delivery_errors = false

  # Enable locale fallbacks for I18n (makes lookups for any locale fall back to
  # the I18n.default_locale when a translation cannot be found).
  config.i18n.fallbacks = true
  config.action_view.raise_on_missing_translations = false

  # Send deprecation notices to registered listeners.
  config.active_support.deprecation = :notify

  config.action_mailer.delivery_method = :smtp
  config.action_mailer.smtp_settings = {
    address: ENV.fetch("SMTP_ADDRESS", ""),
    port: ENV.fetch("SMTP_PORT", "587"),
    authentication: ENV.fetch("SMTP_AUTHENTICATION", "plain"),
    user_name: ENV.fetch("SMTP_USERNAME", ""),
    password: ENV.fetch("SMTP_PASSWORD", ""),
    domain: ENV.fetch("SMTP_DOMAIN") { ENV.fetch("SMTP_ADDRESS", "") },
    enable_starttls_auto: env_enabled?("SMTP_STARTTLS_AUTO", "enabled"),
    openssl_verify_mode: ENV.fetch("SMTP_VERIFY_MODE", "none"),
    ssl: env_enabled?(ENV.fetch("SMTP_SSL", "1")),
    tls: env_enabled?(ENV.fetch("SMTP_TLS", "1"))
  }

  # Use a different logger for distributed setups.
  # require 'syslog/logger'
  # config.logger = ActiveSupport::TaggedLogging.new(Syslog::Logger.new 'app-name')
  # Use default logging formatter so that PID and timestamp are not suppressed.
  config.logger = ActiveSupport::Logger.new(STDOUT)

  file = "#{Rails.root}/log/#{ENV.fetch('RAILS_LOG_FILENAME', 'production.log')}"
  logger = ActiveSupport::Logger.new("#{file}", "daily")
  logger.formatter = config.log_formatter
  config.logger.extend(ActiveSupport::Logger.broadcast(ActiveSupport::TaggedLogging.new(logger)))


  # Do not dump schema after migrations.
  config.active_record.dump_schema_after_migration = false
end
