class Versions::Compare < BrowserAction
  get "/:from_version/:to_version" do
    from_version_exists = File.directory? "../../../generated/#{from_version}"
    to_version_exists = File.directory? "../../../generated/#{to_version}"

    if from_version_exists && to_version_exists
      plain_text "Render something in Versions::Compare"
    else
      plain_text "Unsupported versions provided"
    end
  end
end
