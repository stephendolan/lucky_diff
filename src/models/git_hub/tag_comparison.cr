class GitHub::TagComparison
  include JSON::Serializable

  property url : String
  property html_url : String
  property total_commits : Int32
  property commits : Array(GitHub::Commit)

  def self.fetch(base_tag : String, head_tag : String) : GitHub::TagComparison
    client = HTTP::Client.new("api.github.com", tls: true)
    client.before_request do |request|
      request.headers["Accept"] = "application/vnd.github.v3+json"
    end

    page = 1
    tag_comparison = self.fetch_batch(client, base_tag, head_tag, page)

    while tag_comparison.commits.size < tag_comparison.total_commits
      page += 1
      next_batch = self.fetch_batch(client, base_tag, head_tag, page)
      tag_comparison.commits += next_batch.commits
    end

    tag_comparison
  end

  def self.fetch_batch(client : HTTP::Client, base_tag : String, head_tag : String, page : Int32 = 1, per_page : Int32 = 100)
    params = URI::Params.encode({page: page.to_s, per_page: per_page.to_s})
    response = client.get "/repos/luckyframework/lucky/compare/#{base_tag}...#{head_tag}?#{params}"

    self.from_json(response.body)
  end
end
