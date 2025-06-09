class VersionCompareFlow < BaseFlow
  def visit_homepage
    visit Home::Index.path
  end

  def visit_homepage_with(from, to)
    visit Home::Index.with(from: from, to: to, mode: "unified").path
  end

  def to_version_should_be(version)
    el("select[name='to'] option[selected]").text.should eq(version)
  end

  def from_version_should_be(version)
    el("select[name='from'] option[selected]").text.should eq(version)
  end

  def select_view_mode(mode)
    select_tag_value = case mode
    when "unified"
      "unified"
    when "side"
      "side"
    when "raw"
      "raw"
    when "commits"
      "commits"
    else
      mode
    end
    
    el("select#view-mode").select_option(select_tag_value)
  end
end
