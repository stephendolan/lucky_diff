require "../spec_helper"

describe "Compare default versions on homepage" do
  it "works successfully" do
    flow = VersionCompareFlow.new

    flow.visit_homepage
    flow.from_version_should_be(Version.default_from)
    flow.to_version_should_be(Version.default_to)
  end
end
