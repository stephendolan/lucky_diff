class Versions::ComparePage < MainLayout
  needs diff : String
  needs from : String
  needs to : String

  def content
    div class: "pb-4 space-x-4 text-lg text-center" do
      span from

      span do
        raw("&#8594;")
      end

      span to
    end

    div "Loading diff...", data_controller: "diff-to-html", data_diff_to_html_unified_diff: diff
  end
end
