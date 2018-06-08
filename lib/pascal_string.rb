class PascalString < BinData::Primitive
  uint8 :len, value: -> { data.length }
  string :data, read_length: :len

  def get
    self.data
  end

  def set(v)
    self.data = v
  end
end
