class Home::Index < BrowserAction
  param from : String = Version.default_from
  param to : String = Version.default_to

  get "/" do
    if Version.valid?(from) && Version.valid?(to)
      tempfile = File.tempname("diff_output", ".diff")
      variable = system "diff #{ignore_flags} --speed-large-files -ur #{full_path(from)} #{full_path(to)} > #{tempfile}"
      diff = File.read(tempfile)
      File.delete(tempfile)

      html Versions::ComparePage, diff: diff, from: from, to: to
    else
      flash.failure = "Whoops! Looks like those versions aren't supported (yet)!"
      redirect Home::Index.with(from: Version.default_from, to: Version.default_to)
    end
  end

  private def full_path(version)
    Dir.current + "/generated/" + version
  end

  private def ignore_flags
    ignored_patterns = [
      "settings.secret_key_base",
    ]

    ignored_patterns.map! { |pattern| "-I #{pattern}" }
    ignored_patterns.join(" ")
  end
end
