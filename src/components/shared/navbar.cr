class Shared::Navbar < BaseComponent
  def render
    nav class: "w-full flex justify-between bg-gray-200 px-6 py-4" do
      link "LuckyDiff", to: Home::Index, class: "my-auto font-semibold text-lg"
      a href: "https://github.com/stephendolan/lucky_diff", target: "_blank", class: "h-8 w-8" do
        img src: asset("images/github.svg")
      end
    end
  end
end
