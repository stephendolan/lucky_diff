class Shared::Navbar < BaseComponent
  def render
    nav class: "w-full bg-gray-200 px-6 py-4" do
      link "LuckyDiff", to: Home::Index, class: "font-semibold text-lg"
    end
  end
end
