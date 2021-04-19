class Fathom
  Habitat.create do
    setting domain : String
    setting site_id : String
  end
end

Fathom.configure do |settings|
  settings.domain = "perch.luckydiff.com"
  settings.site_id = fathom_site_id_from_env
end

# Only require this ENV var in production.
private def fathom_site_id_from_env
  return "UNUSED" unless Lucky::Env.production?

  ENV["FATHOM_SITE_ID"]? || raise_missing_key_message
end

private def raise_missing_key_message
  puts "Missing FATHOM_SITE_ID. Set the FATHOM_SITE_ID env variable to 'unused' if not tracking errors, or set the FATHOM_SITE_ID ENV var.".colorize.red
  exit(1)
end
