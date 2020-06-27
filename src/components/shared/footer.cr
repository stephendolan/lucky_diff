class Shared::Footer < BaseComponent
  def render
    nav class: "w-full flex items-center justify-between bg-gray-100 border-t p-2" do
      div do
        a href: "https://kindmetrics.io", target: "_blank", class: "text-xs font-semibold #{link_color}" do
          text "Metrics by KindMetrics"
        end
      end

      iframe src: "https://github.com/sponsors/stephendolan/button",
        title: "Sponsor LuckyDiff",
        height: 35,
        width: 107,
        class: "border-none"
    end
  end

  private def link_color
    "hover:text-gray-800"
  end
end
