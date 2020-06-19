class Home::Index < BrowserAction
  get "/" do
    redirect Versions::Compare
  end
end
