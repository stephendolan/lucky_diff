class Home::Index < BrowserAction
  get "/" do
    redirect Versions::Compare.with(LuckyVersion::DEFAULT_PREVIOUS, LuckyVersion::DEFAULT_LATEST)
  end
end
