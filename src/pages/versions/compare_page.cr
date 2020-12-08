class Versions::ComparePage < MainLayout
  needs diff : String
  needs from : String
  needs to : String

  def page_title
    "v#{from} to v#{to}"
  end

  def content
    form_width = "w-full sm:w-1/2 md:w-1/3 lg:2-1/4"
    form(method: "GET", class: "pb-6 space-y-2 text-center #{form_width} mx-auto", action: Home::Index.path) do
      div class: "flex items-center justify-center" do
        version_picker(input_name: "from", selected_version: from)
        arrow_icon
        version_picker(input_name: "to", selected_version: to)
      end

      div class: "w-full" do
        compare_button
      end
    end

    if diff.empty?
      div class: "pt-10 w-full font-semibold text-center" do
        text "There's no difference between the versions you've selected."
      end
    else
      div "Loading diff...",
        class: "text-center",
        data_controller: "diff-to-html",
        data_diff_to_html_unified_diff: diff
    end
  end

  def version_picker(*, input_name, selected_version)
    select_tag name: input_name, class: "rounded-md py-1 flex-1" do
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
    button_color = "bg-green-500 hover:bg-green-600"
    submit "Compare",
      class: "w-full py-1 mt-2 rounded shadow font-semibold cursor-pointer text-white #{button_color}"
  end
end
