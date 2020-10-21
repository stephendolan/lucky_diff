ENV["LUCKY_ENV"] = "test"
ENV["DEV_PORT"] = "5001"
require "spec"
require "lucky_flow"
require "../src/app"
require "./support/flows/base_flow"
require "./support/**"
require "../db/migrations/**"

# Add/modify files in spec/setup to start/configure programs or run hooks
#
# By default there are scripts for setting up and cleaning the database,
# configuring LuckyFlow, starting the app server, etc.
require "./setup/**"

include Carbon::Expectations
include Lucky::RequestExpectations
include LuckyFlow::Expectations

Habitat.raise_if_missing_settings!

# Added to ensure LuckyFlow has something to use by default
class User
  def id
    0
  end
end
