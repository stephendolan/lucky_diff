LuckyFlow.configure do |settings|
  settings.stop_retrying_after = 200.milliseconds
  settings.base_uri = Lucky::RouteHelper.settings.base_uri
  # LuckyFlow will automatically download and manage the correct driver
end

# Use headless Chrome driver (works with Chromium)
LuckyFlow.default_driver = "headless_chrome"

# For testing with browser window visible:
# LuckyFlow.default_driver = "chrome"
