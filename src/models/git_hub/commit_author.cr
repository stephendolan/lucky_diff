class GitHub::CommitAuthor
  include JSON::Serializable

  property name : String
  property email : String
  property date : Time
end
