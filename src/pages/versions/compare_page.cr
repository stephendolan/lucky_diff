class Versions::ComparePage < MainLayout
  needs diff : String
  needs from : String
  needs to : String

  def content
    form(method: "GET", class: "pb-6 space-y-2 text-lg text-center", action: Home::Index.path) do
      version_picker(input_name: "from", selected_version: from)
      arrow_icon
      version_picker(input_name: "to", selected_version: to)
      compare_button
    end

    div "Loading diff...", data_controller: "diff-to-html", data_diff_to_html_unified_diff: diff
  end

  def version_picker(*, input_name, selected_version)
    select_tag name: input_name, class: "border rounded pr-2" do
      Version::SUPPORTED_VERSIONS.each do |version|
        option version, attrs: [version == selected_version ? :selected : nil].compact
      end
    end
  end

  def arrow_icon
    span class: "px-4" do
      raw("&#8594;")
    end
  end

  def compare_button
    div do
      submit("Compare", class: "w-40 border py-1 rounded border-teal-700 mt-2 cursor-pointer bg-teal-500 hover:bg-teal-600 text-white")
    end
  end
end
