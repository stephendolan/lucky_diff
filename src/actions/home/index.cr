class Home::Index < BrowserAction
  param from : String = Version::DEFAULT_FROM
  param to : String = Version::DEFAULT_TO

  get "/" do
    if Version.valid?(from) && Version.valid?(to)
      from_dir = version_directory(version: from)
      to_dir = version_directory(version: to)

      if valid_directory?(directory: from_dir) && valid_directory?(directory: to_dir)
        tempfile = File.tempname("diff_output", ".diff")
        variable = system "diff #{ignore_flags} -ur #{from_dir} #{to_dir} > #{tempfile}"
        diff = File.read(tempfile)

        html Versions::ComparePage, diff: diff, from: from, to: to
      else
        flash.failure = "Couldn't find apps with versions #{from} and #{to} to compare"
        redirect Home::Index
      end
    else
      flash.failure = "Invalid version numbers provided"
      redirect Home::Index
    end
  end

  private def version_directory(version)
    Dir.current + "/generated/" + version
  end

  private def valid_directory?(directory)
    File.directory? directory
  end

  private def ignore_flags
    ignored_patterns = [
      "settings.secret_key_base",
    ]

    ignored_patterns.map! { |pattern| "-I #{pattern}" }
    ignored_patterns.join(" ")
  end
end
