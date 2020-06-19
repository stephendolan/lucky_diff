class Versions::ComparePage < MainLayout
  needs diff : String

  def content
    div diff, data_controller: "hello"
  end
end
