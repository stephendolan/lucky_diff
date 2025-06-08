class VersionCompareFlow < BaseFlow
  def visit_homepage
    visit Home::Index.path
  end

  def visit_homepage_with(from, to)
    visit Home::Index.with(from: from, to: to).path
  end

  def to_version_should_be(version)
    el("select[name='to'] option[selected]").text.should eq(version)
  end

  def from_version_should_be(version)
    el("select[name='from'] option[selected]").text.should eq(version)
  end
end
