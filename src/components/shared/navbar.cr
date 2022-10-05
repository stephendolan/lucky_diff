class Shared::Navbar < BaseComponent
  def render
    nav class: "w-full flex justify-between bg-gray-200 border-b px-10 py-4" do
      link "LuckyDiff", to: logo_link, class: "my-auto font-semibold text-2xl #{link_color}"

      div class: "flex items-center space-x-4" do
        github_source_button
        sponsorship_button
      end
    end
  end

  private def github_link
    "https://github.com/stephendolan/lucky_diff"
  end

  private def sponsorship_link
    "https://github.com/sponsors/stephendolan"
  end

  private def link_color
    "hover:text-gray-800"
  end

  private def github_source_button
    a href: github_link, target: "_blank", class: "flex space-x-2 bg-gray-300 hover:bg-opacity-70 px-4 py-2 rounded-md" do
      tag "svg", aria_hidden: "true", class: "svg-inline--fa fa-github fa-fw w-6 h-6", data_icon: "github", data_prefix: "fab", focusable: "false", role: "img", viewBox: "0 0 496 512", xmlns: "http://www.w3.org/2000/svg" do
        tag "path", d: "M165.9 397.4c0 2-2.3 3.6-5.2 3.6-3.3.3-5.6-1.3-5.6-3.6 0-2 2.3-3.6 5.2-3.6 3-.3 5.6 1.3 5.6 3.6zm-31.1-4.5c-.7 2 1.3 4.3 4.3 4.9 2.6 1 5.6 0 6.2-2s-1.3-4.3-4.3-5.2c-2.6-.7-5.5.3-6.2 2.3zm44.2-1.7c-2.9.7-4.9 2.6-4.6 4.9.3 2 2.9 3.3 5.9 2.6 2.9-.7 4.9-2.6 4.6-4.6-.3-1.9-3-3.2-5.9-2.9zM244.8 8C106.1 8 0 113.3 0 252c0 110.9 69.8 205.8 169.5 239.2 12.8 2.3 17.3-5.6 17.3-12.1 0-6.2-.3-40.4-.3-61.4 0 0-70 15-84.7-29.8 0 0-11.4-29.1-27.8-36.6 0 0-22.9-15.7 1.6-15.4 0 0 24.9 2 38.6 25.8 21.9 38.6 58.6 27.5 72.9 20.9 2.3-16 8.8-27.1 16-33.7-55.9-6.2-112.3-14.3-112.3-110.5 0-27.5 7.6-41.3 23.6-58.9-2.6-6.5-11.1-33.3 2.6-67.9 20.9-6.5 69 27 69 27 20-5.6 41.5-8.5 62.8-8.5s42.8 2.9 62.8 8.5c0 0 48.1-33.6 69-27 13.7 34.7 5.2 61.4 2.6 67.9 16 17.7 25.8 31.5 25.8 58.9 0 96.5-58.9 104.2-114.8 110.5 9.2 7.9 17 22.9 17 46.4 0 33.7-.3 75.4-.3 83.6 0 6.5 4.6 14.4 17.3 12.1C428.2 457.8 496 362.9 496 252 496 113.3 383.5 8 244.8 8zM97.2 352.9c-1.3 1-1 3.3.7 5.2 1.6 1.6 3.9 2.3 5.2 1 1.3-1 1-3.3-.7-5.2-1.6-1.6-3.9-2.3-5.2-1zm-10.8-8.1c-.7 1.3.3 2.9 2.3 3.9 1.6 1 3.6.7 4.3-.7.7-1.3-.3-2.9-2.3-3.9-2-.6-3.6-.3-4.3.7zm32.4 35.6c-1.6 1.3-1 4.3 1.3 6.2 2.3 2.3 5.2 2.6 6.5 1 1.3-1.3.7-4.3-1.3-6.2-2.2-2.3-5.2-2.6-6.5-1zm-11.4-14.7c-1.6 1-1.6 3.6 0 5.9 1.6 2.3 4.3 3.3 5.6 2.3 1.6-1.3 1.6-3.9 0-6.2-1.4-2.3-4-3.3-5.6-2z", fill: "currentColor"
      end

      span "Source", class: "hidden lg:block font-medium text-black-600"
    end
  end

  private def sponsorship_button
    a href: sponsorship_link, target: "_blank", class: "flex space-x-2 bg-gray-300 hover:bg-opacity-70 px-4 py-2 rounded-md" do
      tag "svg", class: "w-6 h-6 text-red-600", fill: "currentColor", stroke: "currentColor", stroke_width: "1.5", viewbox: "0 0 24 24", xmlns: "http://www.w3.org/2000/svg" do
        tag "path", d: "M21 8.25c0-2.485-2.099-4.5-4.688-4.5-1.935 0-3.597 1.126-4.312 2.733-.715-1.607-2.377-2.733-4.313-2.733C5.1 3.75 3 5.765 3 8.25c0 7.22 9 12 9 12s9-4.78 9-12z", stroke_linecap: "round", stroke_linejoin: "round"
      end

      span "Sponsor", class: "hidden lg:block font-medium text-black-600"
    end
  end

  private def logo_link
    default_from = Version.default_from
    default_to = Version.default_to

    Home::Index.with(from: default_from, to: default_to)
  end
end
