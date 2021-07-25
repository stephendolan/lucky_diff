class GitHub::CommitDetails
  include JSON::Serializable

  property url : String
  property author : GitHub::CommitAuthor
  property message : String
end
