# Include modules and add methods that are for all API requests
abstract class ApiAction < Lucky::Action
  include Lucky::EnforceUnderscoredRoute

  # APIs typically do not need to send cookie/session data.
  # Remove this line if you want to send cookies in the response header.
  disable_cookies

  accepted_formats [:json]
end
