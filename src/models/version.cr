class Version
  SUPPORTED_VERSIONS = [
    "0.21.0",
    "0.22.0",
  ]

  DEFAULT_FROM = SUPPORTED_VERSIONS.last(2).first
  DEFAULT_TO   = SUPPORTED_VERSIONS.last

  def self.valid?(version)
    SUPPORTED_VERSIONS.includes? version
  end
end
