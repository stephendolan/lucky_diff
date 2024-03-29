abstract class MainLayout
  include Lucky::HTMLPage

  abstract def content
  abstract def page_title

  # The default page title. It is passed to `Shared::LayoutHead`.
  #
  # Add a `page_title` method to pages to override it. You can also remove
  # This method so every page is required to have its own page title.
  def page_title
    "LuckyDiff"
  end

  def render
    html_doctype

    html lang: "en" do
      mount Shared::LayoutHead, page_title: page_title

      body class: "flex flex-col min-h-screen" do
        mount Shared::Navbar
        mount Shared::FlashMessages, context.flash

        div class: "flex-grow mx-10 my-6" do
          content
        end

        mount Shared::Footer
      end
    end
  end
end
