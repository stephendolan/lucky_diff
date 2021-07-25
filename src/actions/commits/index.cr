class Commits::Index < BrowserAction
  param from : String = Version.default_from
  param to : String = Version.default_to

  get "/commits" do
    if Version.valid?(params.get?(:from)) && Version.valid?(params.get?(:to))
      tag_comparison = GitHub::TagComparison.fetch(base_tag: "v#{from}", head_tag: "v#{to}")

      html Commits::IndexPage, comparison: tag_comparison, from: from, to: to
    else
      redirect to: Home::Index.with(Version.default_from, Version.default_to)
    end
  end
end
