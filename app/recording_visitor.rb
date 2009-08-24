
class RecordingVisitor < Hash
  def apply(key, value)
    self[key]= value
  end
end



