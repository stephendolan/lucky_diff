class Versions::ComparePage < MainLayout
  needs diff : String

  def content
    div "Loading diff...", data_controller: "diff-to-html", data_diff_to_html_unified_diff: diff
  end
end
