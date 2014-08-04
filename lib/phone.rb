class Phone
  attr_reader :value
  RegExp = /\A(\+[0-9]{11})\Z/i

  def self.sanitize value
    value.strip.gsub(/[\ \-()]/,'')
  end

  def initialize value
    @value = self.class.sanitize value.to_s
  end

  def valid?
    (@value =~ RegExp) == 0
  end

  def to_s
    @value
  end
end
