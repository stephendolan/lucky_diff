class Shared::FlashMessages < BaseComponent
  needs flash : Lucky::FlashStore

  def render
    return if flash.empty?

    div class: "bg-primary-900 text-center py-4 lg:px-4" do
      flash.each do |flash_type, flash_message|
        div class: "p-2 bg-primary-800 items-center text-primary-100 leading-none lg:rounded-full flex lg:inline-flex", role: "alert" do
          span flash_type, class: "flex rounded-full bg-primary-500 px-2 py-1 uppercase text-xs font-bold mr-3"
          span flow_id: "flash", class: "font-semibold mr-2 text-left flex-auto" do
            text flash_message
          end
        end
      end
    end
  end
end
