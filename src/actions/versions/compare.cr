class Versions::Compare < BrowserAction
  get "/compare/:from_version/:to_version" do
    if Version.valid?(from_version) && Version.valid?(to_version)
      from_dir = version_directory(version: from_version)
      to_dir = version_directory(version: to_version)

      if valid_directory?(directory: from_dir) && valid_directory?(directory: to_dir)
        tempfile = File.tempname("diff_output", ".diff")
        variable = system "diff #{ignore_flags} -ur #{from_dir} #{to_dir} > #{tempfile}"
        diff = File.read(tempfile)

        html Versions::ComparePage, diff: diff
      else
        redirect Home::Index
      end
    else
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
