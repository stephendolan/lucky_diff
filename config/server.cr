# Here is where you configure the Lucky server
#
# Look at config/route_helper.cr if you want to change the domain used when
# generating links with `Action.url`.
Lucky::Server.configure do |settings|
  if LuckyEnv.production?
    settings.secret_key_base = secret_key_from_env
    settings.host = "0.0.0.0"
    settings.port = ENV["PORT"].to_i
    settings.gzip_enabled = true
    # By default certain content types will be gzipped.
    # For a full list look in
    # https://github.com/luckyframework/lucky/blob/master/src/lucky/server.cr
    # To add additional extensions do something like this:
    # settings.gzip_content_types << "content/type"
  else
    settings.secret_key_base = "xS78KiLuLlxWVibUX3Ef5wlHHHVqnj6INQHlRbOQ9yI="
    # Change host/port in config/watch.yml
    # Alternatively, you can set the DEV_PORT env to set the port for local development
    settings.host = Lucky::ServerSettings.host
    settings.port = Lucky::ServerSettings.port
  end

  # By default Lucky will serve static assets in development and production.
  #
  # However you could use a CDN when in production like this:
  #
  #   Lucky::Server.configure do |settings|
  #     if LuckyEnv.production?
  #       settings.asset_host = "https://mycdnhost.com"
  #     else
  #       settings.asset_host = ""
  #     end
  #   end
  settings.asset_host = "" # Lucky will serve assets
end

Lucky::ForceSSLHandler.configure do |settings|
  settings.enabled = LuckyEnv.production?
  settings.strict_transport_security = {max_age: 1.year, include_subdomains: true}
end

private def secret_key_from_env
  ENV["SECRET_KEY_BASE"]? || raise_missing_secret_key_in_production
end

private def raise_missing_secret_key_in_production
  puts "Please set the SECRET_KEY_BASE environment variable. You can generate a secret key with 'lucky gen.secret_key'".colorize.red
  exit(1)
end
