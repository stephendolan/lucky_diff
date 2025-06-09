class Api::Commits::Index < ApiAction
  param from : String = Version.default_from
  param to : String = Version.default_to

  get "/api/commits" do
    if Version.valid?(params.get?(:from)) && Version.valid?(params.get?(:to))
      tag_comparison = GitHub::TagComparison.fetch(base_tag: "v#{from}", head_tag: "v#{to}")
      
      json({
        commits: tag_comparison.commits.map do |commit|
          {
            url: commit.url,
            html_url: commit.html_url,
            commit: {
              message: commit.details.message,
              author: {
                name: commit.details.author.name,
                date: commit.details.author.date
              }
            },
            author: commit.author ? {
              login: commit.author.not_nil!.login,
              avatar_url: commit.author.not_nil!.avatar_url
            } : nil,
            committer: {
              login: commit.committer.login,
              avatar_url: commit.committer.avatar_url
            }
          }
        end,
        total_commits: tag_comparison.total_commits,
        html_url: tag_comparison.html_url
      })
    else
      head 422
    end
  end
end