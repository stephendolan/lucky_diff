class Versions::ComparePage < MainLayout
  needs diff : String
  needs from : String
  needs to : String
  needs view_mode : String

  def page_title
    "v#{from} to v#{to}"
  end

  def content
    div class: "max-w-7xl mx-auto sm:px-4 md:px-6 lg:px-8" do

      # View mode selector and diff content
      if diff.empty?
        div class: "bg-white rounded-lg shadow-sm border border-gray-200 p-12 text-center" do
          div class: "text-gray-500" do
            tag "svg", class: "mx-auto h-12 w-12 text-gray-400 mb-4", fill: "none", stroke: "currentColor", viewbox: "0 0 24 24" do
              tag "path", stroke_linecap: "round", stroke_linejoin: "round", stroke_width: "2", d: "M9 5H7a2 2 0 00-2 2v12a2 2 0 002 2h10a2 2 0 002-2V7a2 2 0 00-2-2h-2M9 5a2 2 0 002 2h2a2 2 0 002-2M9 5a2 2 0 012-2h2a2 2 0 012 2"
            end
            h3 "No changes found", class: "text-lg font-medium text-gray-900 mb-2"
            para "There's no difference between the versions you've selected.", class: "text-sm"
          end
        end
      else
        # Combined header and diff container
        div class: "bg-white sm:rounded-lg shadow-sm sm:border sm:border-gray-200",
          data_controller: "diff-to-html",
          data_diff_to_html_unified_diff: diff,
          data_diff_to_html_initial_mode: view_mode do
          
          # Header with view controls and version selectors
          div class: "border-b border-gray-200 p-2 sm:p-4" do
            form(method: "GET", action: Home::Index.path, data_action: "change->diff-to-html#formChanged") do
              # Hidden field to preserve view mode
              input type: "hidden", name: "mode", value: view_mode, data_diff_to_html_target: "modeInput"
              
              div class: "flex flex-row justify-between items-center gap-3" do
                # File count and version selectors
                div class: "flex flex-col gap-2 flex-1" do
                  h2 "Files changed (#{diff.scan(/^diff --color=never/m).size})", 
                    class: "text-base sm:text-lg font-semibold text-gray-900",
                    data_diff_to_html_target: "filesChangedTitle"
                  
                  span class: "text-xs sm:text-sm text-gray-500 flex flex-wrap items-center gap-2" do
                    text "Comparing Lucky"
                    version_picker(input_name: "from", selected_version: from, auto_submit: true)
                    text "to"
                    version_picker(input_name: "to", selected_version: to, auto_submit: true)
                  end
                end
                
                # View mode selector
                div class: "flex items-center gap-2 flex-shrink-0" do
                  label "View:", for: "view-mode", class: "text-xs sm:text-sm font-medium text-gray-700"
                  select_tag id: "view-mode",
                    class: "rounded-md border-gray-300 text-xs sm:text-sm py-1 pl-2 pr-8",
                    data_diff_to_html_target: "viewMode",
                    data_action: "change->diff-to-html#viewModeChanged" do
                    option "Unified", value: "unified", selected: view_mode == "unified"
                    option "Side by Side", value: "side", selected: view_mode == "side"
                    option "Raw", value: "raw", selected: view_mode == "raw"
                    option "Commits", value: "commits", selected: view_mode == "commits"
                  end
                end
              end
            end
          end
          
          # Diff content area
          div class: "p-2 sm:p-4 overflow-x-auto" do
            div "Loading diff...", class: "min-h-[200px]", data_diff_to_html_target: "content"
          end
        end
      end
    end
  end

  def version_picker(*, input_name, selected_version, auto_submit = false)
    base_attrs = {
      name: input_name,
      id: input_name,
      class: "rounded-md border-gray-300 shadow-sm focus:border-emerald-500 focus:ring-emerald-500 text-xs sm:text-sm py-0.5 sm:py-1 pl-1.5 sm:pl-2 pr-5 sm:pr-6"
    }
    
    if auto_submit
      select_tag **base_attrs, data_action: "change->diff-to-html#versionChanged" do
        Version::SUPPORTED_VERSIONS.each do |version|
          option version, attrs: [version == selected_version ? :selected : nil].compact
        end
      end
    else
      select_tag **base_attrs do
        Version::SUPPORTED_VERSIONS.each do |version|
          option version, attrs: [version == selected_version ? :selected : nil].compact
        end
      end
    end
  end


end
