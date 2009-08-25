
class RecordingVisitor < Hash
  def apply(item)
    self[item.name]= item.code
  end
end



