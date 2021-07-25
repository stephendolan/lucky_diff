class GitHub::Commit
  include JSON::Serializable

  property url : String
  property html_url : String
  @[JSON::Field(key: "commit")]
  property details : GitHub::CommitDetails
  property author : GitHub::User?
  property committer : GitHub::User
end
