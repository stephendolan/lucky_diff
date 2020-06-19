class Shared::Navbar < BaseComponent
  def render
    nav class: "w-full bg-gray-200 px-6 py-4" do
      link "LuckyDiff",
        to: Versions::Compare.with(
          from_version: Version::DEFAULT_FROM,
          to_version: Version::DEFAULT_TO
        ),
        class: "font-semibold text-lg"
    end
  end
end
