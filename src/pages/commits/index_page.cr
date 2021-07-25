class Commits::IndexPage < MainLayout
  needs comparison : GitHub::TagComparison
  needs from : String
  needs to : String

  def content
    div class: "bg-white shadow overflow-hidden sm:rounded-md" do
      div class: "bg-gray-100 px-4 py-5 border-b border-gray-200 sm:px-6" do
        div class: "-ml-4 -mt-4 flex justify-between items-center flex-wrap sm:flex-nowrap" do
          div class: "ml-4 mt-4" do
            div class: "flex items-center" do
              div class: "ml-4" do
                h3 class: "text-lg leading-6 font-medium text-gray-900" do
                  text "Commit log"
                end
                para class: "text-sm text-gray-500 flex items-end space-x-2" do
                  span "v#{from} - v#{to}"
                  span "(#{comparison.total_commits} commits)", class: "text-xs"
                end
              end
            end
          end
          div class: "ml-4 mt-4 flex-shrink-0 flex" do
            a href: comparison.html_url, target: "_blank", class: "relative inline-flex items-center px-4 py-2 border border-gray-300 shadow-sm text-sm font-medium rounded-md text-gray-700 bg-white hover:bg-gray-50 focus:outline-none focus:ring-2 focus:ring-offset-2 focus:ring-primary-500", type: "button" do
              tag "svg", class: "-ml-1 mr-2 h-5 w-5 text-gray-400", fill: "currentColor", viewbox: "0 0 20 20", xmlns: "http://www.w3.org/2000/svg" do
                tag "path", d: "M11 3a1 1 0 100 2h2.586l-6.293 6.293a1 1 0 101.414 1.414L15 6.414V9a1 1 0 102 0V4a1 1 0 00-1-1h-5z"
                tag "path", d: "M5 5a2 2 0 00-2 2v8a2 2 0 002 2h8a2 2 0 002-2v-3a1 1 0 10-2 0v3H5V7h3a1 1 0 000-2H5z"
              end
              span do
                text "View in GitHub"
              end
            end
            link to: Home::Index.with(from: from, to: to), class: "ml-3 relative inline-flex items-center px-4 py-2 border border-gray-300 shadow-sm text-sm font-medium rounded-md text-gray-700 bg-white hover:bg-gray-50 focus:outline-none focus:ring-2 focus:ring-offset-2 focus:ring-primary-500", type: "button" do
              tag "svg", aria_hidden: "true", class: "-ml-1 mr-2 h-5 w-5 text-gray-400", fill: "currentColor", viewbox: "0 0 20 20", xmlns: "http://www.w3.org/2000/svg" do
                tag "path", clip_rule: "evenodd", d: "M9.707 16.707a1 1 0 01-1.414 0l-6-6a1 1 0 010-1.414l6-6a1 1 0 011.414 1.414L5.414 9H17a1 1 0 110 2H5.414l4.293 4.293a1 1 0 010 1.414z", fill_rule: "evenodd"
              end
              span do
                text "Back to the diff"
              end
            end
          end
        end
      end

      ul class: "divide-y divide-gray-200" do
        comparison.commits.reverse.each do |commit|
          render_commit(commit)
        end
      end
    end
  end

  private def render_commit(commit : GitHub::Commit)
    # Sometimes the author is null for commits, but committer will always be present
    github_user = commit.author || commit.committer

    li do
      a class: "block hover:bg-gray-50", href: commit.html_url, target: "_blank" do
        div class: "flex items-center px-4 py-4 sm:px-6" do
          div class: "min-w-0 flex-1 flex items-center" do
            div class: "flex-shrink-0" do
              img alt: "#{github_user.login} avatar", class: "h-12 w-12 rounded-full ring-1 ring-gray-400", src: github_user.avatar_url
            end
            div class: "min-w-0 flex-1 px-4 md:grid md:grid-cols-2 md:gap-4" do
              div do
                para "#{commit.details.author.name} (@#{github_user.login})", class: "text-sm font-medium text-primary-600 truncate"
                para class: "mt-2 flex items-center text-sm text-gray-500" do
                  span commit.details.message, class: "truncate"
                end
              end
              div class: "hidden md:block" do
                div do
                  para class: "mt-2 flex items-center text-sm text-gray-500 space-x-1" do
                    tag "svg", class: "flex-shrink-0 mr-1.5 h-5 w-5", fill: "currentColor", viewbox: "0 0 20 20", xmlns: "http://www.w3.org/2000/svg" do
                      tag "path", clip_rule: "evenodd", d: "M12.316 3.051a1 1 0 01.633 1.265l-4 12a1 1 0 11-1.898-.632l4-12a1 1 0 011.265-.633zM5.707 6.293a1 1 0 010 1.414L3.414 10l2.293 2.293a1 1 0 11-1.414 1.414l-3-3a1 1 0 010-1.414l3-3a1 1 0 011.414 0zm8.586 0a1 1 0 011.414 0l3 3a1 1 0 010 1.414l-3 3a1 1 0 11-1.414-1.414L16.586 10l-2.293-2.293a1 1 0 010-1.414z", fill_rule: "evenodd"
                    end
                    text "luckyframework/lucky"
                  end
                  para class: "mt-2 flex items-center text-sm text-gray-500 space-x-1" do
                    tag "svg", aria_hidden: "true", class: "flex-shrink-0 mr-1.5 h-5 w-5 text-green-400", fill: "currentColor", viewbox: "0 0 20 20", xmlns: "http://www.w3.org/2000/svg" do
                      tag "path", clip_rule: "evenodd", d: "M10 18a8 8 0 100-16 8 8 0 000 16zm3.707-9.293a1 1 0 00-1.414-1.414L9 10.586 7.707 9.293a1 1 0 00-1.414 1.414l2 2a1 1 0 001.414 0l4-4z", fill_rule: "evenodd"
                    end
                    text "Committed on "
                    time commit.details.author.date.to_s("%B %-d, %Y")
                  end
                end
              end
            end
          end
          div do
            tag "svg", aria_hidden: "true", class: "h-5 w-5 text-gray-400", fill: "currentColor", viewbox: "0 0 20 20", xmlns: "http://www.w3.org/2000/svg" do
              tag "path", clip_rule: "evenodd", d: "M7.293 14.707a1 1 0 010-1.414L10.586 10 7.293 6.707a1 1 0 011.414-1.414l4 4a1 1 0 010 1.414l-4 4a1 1 0 01-1.414 0z", fill_rule: "evenodd"
            end
          end
        end
      end
    end
  end
end
