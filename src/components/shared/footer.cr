class Shared::Footer < BaseComponent
  def render
    nav class: "w-full flex items-center bg-gray-100 border-t p-2" do
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
