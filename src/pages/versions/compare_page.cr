class Versions::ComparePage < MainLayout
  needs diff : String
  needs from : String
  needs to : String

  def page_title
    "v#{from} to v#{to}"
  end

  def content
    section class: "relative" do
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

      div class: "absolute top-0 right-0" do
        commit_log_button
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
    button_color = "bg-primary-500 hover:bg-primary-600"
    submit "Compare",
      class: "w-full py-1 mt-2 rounded shadow font-semibold cursor-pointer text-white #{button_color}"
  end

  def commit_log_button
    button_color = "bg-primary-500 hover:bg-primary-600"
    link to: Commits::Index.with(from: from, to: to), class: "w-full py-1 px-4 hidden sm:flex items-center rounded shadow font-semibold cursor-pointer text-sm text-white #{button_color}" do
      tag "svg", class: "h-5 w-5 mr-1.5", fill: "currentColor", viewbox: "0 0 20 20", xmlns: "http://www.w3.org/2000/svg" do
        tag "path", d: "M7 3a1 1 0 000 2h6a1 1 0 100-2H7zM4 7a1 1 0 011-1h10a1 1 0 110 2H5a1 1 0 01-1-1zM2 11a2 2 0 012-2h12a2 2 0 012 2v4a2 2 0 01-2 2H4a2 2 0 01-2-2v-4z"
      end

      text "Commit log"
    end
  end
end
