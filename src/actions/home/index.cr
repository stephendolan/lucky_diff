class Home::Index < BrowserAction
  param from : String = Version.default_from
  param to : String = Version.default_to

  get "/" do
    if Version.valid?(params.get?(:from)) && Version.valid?(params.get?(:to))
      html Versions::ComparePage, diff: sanitize_diff(version_diff), from: from, to: to
    else
      flash.info = "You requested an unsupported version!"
      redirect to: Home::Index.with(from, to)
    end
  end

  # Because we store scaffolded apps in different directories, we remove
  # those details to avoid every file getting the "Renamed" designation.
  private def sanitize_diff(diff)
    diff.gsub(/\S+\/generated\/(#{from}|#{to})/, "app")
  end

  private def full_path(version)
    Dir.current + "/generated/" + version
  end

  private def version_diff
    tempfile = File.tempname("diff_output", ".diff")
    system "diff #{ignore_flags} -Nr -U #{context_lines} #{full_path(from)} #{full_path(to)} > #{tempfile}"
    File.read(tempfile)
  ensure
    File.delete(tempfile) if tempfile
  end

  private def context_lines
    20
  end

  private def ignore_flags
    ignored_patterns = [
      "settings.secret_key_base",
    ]

    ignored_patterns.map! { |pattern| "-I #{pattern}" }
    ignored_patterns.join(" ")
  end
end
