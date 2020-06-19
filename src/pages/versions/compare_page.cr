class Versions::ComparePage < MainLayout
  needs diff : String
  needs from : String
  needs to : String

  def content
    form(method: "GET", class: "pb-4 space-y-2 text-lg text-center", action: Home::Index.path) do
      select_tag name: "from", class: "border rounded pr-2" do
        Version::SUPPORTED_VERSIONS.each do |version|
          option version, attrs: [version == from ? :selected : nil].compact
        end
      end

      span class: "px-4" do
        raw("&#8594;")
      end

      select_tag name: "to", class: "border rounded pr-2" do
        Version::SUPPORTED_VERSIONS.each do |version|
          option version, attrs: [version == to ? :selected : nil].compact
        end
      end

      div do
        submit("Compare", class: "w-40 border rounded cursor-pointer")
      end
    end

    div "Loading diff...", data_controller: "diff-to-html", data_diff_to_html_unified_diff: diff
  end
end
