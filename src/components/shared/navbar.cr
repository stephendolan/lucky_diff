class Shared::Navbar < BaseComponent
  def render
    nav class: "w-full flex justify-between bg-gray-200 px-6 py-4" do
      link "LuckyDiff", to: logo_link, class: "my-auto font-semibold text-lg"
      a href: github_link, target: "_blank", class: "h-8 w-8" do
        img src: asset("images/github.svg")
      end
    end
  end

  private def github_link
    "https://github.com/stephendolan/lucky_diff"
  end

  private def logo_link
    default_from = Version.default_from
    default_to = Version.default_to

    Home::Index.with(from: default_from, to: default_to)
  end
end
