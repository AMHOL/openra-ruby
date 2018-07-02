class BigInteger < BinData::BasePrimitive
  def value_to_binary_string(value)
    value = value.abs
    bytes = []

    loop do
      seven_bit_byte = value & 0x7f
      value >>= 7
      has_more = value.nonzero? ? 0x80 : 0
      byte = has_more | seven_bit_byte
      bytes.push(byte)

      break if has_more.zero?
    end

    bytes.collect { |b| b.chr }.join
  end

  def read_and_return_value(io)
    value = 0
    bit_shift = 0

    loop do
      byte = read_uint8(io)
      has_more = byte & 0x80
      seven_bit_byte = byte & 0x7f
      value |= seven_bit_byte << bit_shift
      bit_shift += 7

      break if has_more.zero?
    end

    value
  end

  def sensible_default
    0
  end

  def read_uint8(io)
    io.readbytes(1).unpack("C").at(0)
  end
end
