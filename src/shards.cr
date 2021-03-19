# Load .env file before any other config or app code
require "lucky_env"

if Lucky::Env.development?
  LuckyEnv.load(".env")
end

# Require your shards here
require "avram"
require "lucky"
require "raven"
require "raven/integrations/lucky"
