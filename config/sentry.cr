Raven.configure do |config|
  config.async = true
  config.current_environment = Lucky::Env.name
  config.environments = %w(production)

  if Lucky::Env.production?
    config.dsn = sentry_dsn_from_env
  end
end

private def sentry_dsn_from_env
  ENV["SENTRY_DSN"]? || raise_missing_key_message
end

private def raise_missing_key_message
  puts "Missing SENTRY_DSN. Set the SENTRY_DSN env variable to 'unused' if not tracking errors, or set the SENTRY_DSN ENV var.".colorize.red
  exit(1)
end
