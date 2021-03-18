# Load .env file before any other config or app code
require "lucky_env"

unless Lucky::Env.production?
  LuckyEnv.load(".env")
end

# Require your shards here
require "avram"
require "lucky"
require "raven"
require "raven/integrations/lucky"
