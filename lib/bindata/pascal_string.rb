class PascalString < BinData::Primitive
  big_integer :len, value: -> { data.length }
  string :data, read_length: :len

  def get
    self.data
  end

  def set(v)
    self.data = v
  end
end
