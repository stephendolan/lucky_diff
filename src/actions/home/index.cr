class Home::Index < BrowserAction
  param from : String = Version.default_from
  param to : String = Version.default_to

  get "/" do
    if Version.valid?(params.get?(:from)) && Version.valid?(params.get?(:to))
      html Versions::ComparePage, diff: sanitize_diff(version_diff), from: from, to: to
    else
      redirect to: Home::Index.with(Version.default_from, Version.default_to)
    end
  end

  # Because we store scaffolded apps in different directories, we remove
  # those details to avoid every file getting the "Renamed" designation.
  # We also remove timestamps to prevent files from appearing as renamed.
  private def sanitize_diff(diff)
    diff
      .gsub(/\S+\/generated\/(#{from}|#{to})\//, "")
      .gsub(/(\s+\d{4}-\d{2}-\d{2}\s+\d{2}:\d{2}:\d{2}(?:\.\d+)?(?:\s+[+-]\d{4})?)/, "")
      .gsub(/(\.\d{9}\s+[+-]\d{4})/, "")
  end

  private def full_path(version)
    Dir.current + "/generated/" + version
  end

  private def version_diff
    tempfile = File.tempname("diff_output", ".diff")
    system "diff #{ignore_flags} #{whitespace_flags} -Nr -U #{context_lines} #{full_path(from)} #{full_path(to)} > #{tempfile}"
    File.read(tempfile)
  ensure
    File.delete(tempfile) if tempfile
  end

  private def context_lines
    20
  end

  private def whitespace_flags
    if LuckyEnv.production?
      # Production on Linux/Alpine has GNU diff
      %w[
        --ignore-space-change
        --ignore-tab-expansion
      ].join(" ")
    else
      # Development on macOS has BSD diff
      # -b is equivalent to --ignore-space-change
      "-b"
    end
  end

  private def ignore_flags
    ignored_patterns = [
      "\\s*settings.secret_key_base.*",
    ]

    ignored_patterns.map! { |pattern| "-I #{pattern}" }
    ignored_patterns.join(" ")
  end
end
