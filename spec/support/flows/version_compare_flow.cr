class VersionCompareFlow < BaseFlow
  def visit_homepage
    visit Home::Index
  end

  def visit_homepage_with(from, to)
    visit Home::Index.with(from: from, to: to)
  end

  def to_version_should_be(version)
    to_version(version).should be_on_page
  end

  def from_version_should_be(version)
    from_version(version).should be_on_page
  end

  private def from_version(version)
    el("select[name='from'] > option:checked", text: version)
  end

  private def to_version(version)
    el("select[name='to'] > option:checked", text: version)
  end
end
