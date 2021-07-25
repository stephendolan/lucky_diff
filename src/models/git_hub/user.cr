class GitHub::User
  include JSON::Serializable

  property login : String
  property avatar_url : String
  property html_url : String
end
