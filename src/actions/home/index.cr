class Home::Index < BrowserAction
  param from : String = Version.default_from
  param to : String = Version.default_to

  get "/" do
    if Version.valid?(from) && Version.valid?(to)
      html Versions::ComparePage, diff: version_diff, from: from, to: to
    else
      flash.info = "You requested an unsupported version!"
      redirect Home::Index.with(from: Version.default_from, to: Version.default_to)
    end
  end

  private def full_path(version)
    Dir.current + "/generated/" + version
  end

  private def version_diff
    tempfile = File.tempname("diff_output", ".diff")
    variable = system "diff #{ignore_flags} --speed-large-files -ur #{full_path(from)} #{full_path(to)} > #{tempfile}"
    File.read(tempfile)
  ensure
    File.delete(tempfile) if tempfile
  end

  private def ignore_flags
    ignored_patterns = [
      "settings.secret_key_base",
    ]

    ignored_patterns.map! { |pattern| "-I #{pattern}" }
    ignored_patterns.join(" ")
  end
end
