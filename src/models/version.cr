class Version
  SUPPORTED_VERSIONS = [
    "0.17.0",
    "0.18.0",
    "0.19.0",
    "0.20.0",
    "0.21.0",
    "0.22.0",
    "0.23.0",
    "0.24.0",
    "0.25.0",
    "0.26.0",
    "0.27.2",
    "0.28.0",
  ]

  def self.valid?(version)
    return false if version.nil?

    SUPPORTED_VERSIONS.includes?(version) && Dir.exists?(Dir.current + "/generated/" + version)
  end

  def self.default_from
    SUPPORTED_VERSIONS[-2]
  end

  def self.default_to
    SUPPORTED_VERSIONS[-1]
  end
end
