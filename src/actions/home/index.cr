class Home::Index < BrowserAction
  get "/" do
    redirect Versions::Compare.with(Version::DEFAULT_FROM, Version::DEFAULT_TO)
  end
end
