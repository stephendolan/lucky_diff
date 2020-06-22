class About::IndexPage < MainLayout
  def content
    h1 "Upgrades, made better.", class: "text-3xl font-bold text-center"

    div class: "text-xl space-y-10 lg:px-20 mt-10 text-center" do
      para do
        text "LuckyDiff was created to help Lucky developers migrate quickly between versions."
      end

      para do
        text "It is heavily inspired by "
        a "RailsDiff.org", class: link_class, href: "http://railsdiff.org", target: "_blank"
        text "."
      end

      para do
        text "It is not owned or maintained by the "
        a "Lucky", class: link_class, href: "https://github.com/luckyframework/lucky", target: "_blank"
        text " team."
      end

      para do
        text "It is provided for free by the community, for the community."
      end
    end
  end

  private def link_class
    "text-blue-700 hover:text-blue-500"
  end
end
