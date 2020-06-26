require "../spec_helper"

describe "Compare default versions on homepage" do
  it "works successfully" do
    flow = VersionCompareFlow.new

    flow.visit_homepage_with(from: "0.17.0", to: "0.18.0")
    flow.from_version_should_be("0.17.0")
    flow.to_version_should_be("0.18.0")
  end
end
