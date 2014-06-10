module OshparkArrayExtensions
  def to_multipart key
    prefix = "#{key}[]"
    collect {|a| a.to_multipart(prefix)}.flatten.compact
  end

  def to_query key
    prefix = "#{key}[]"
    collect { |value| value.to_query(prefix) }.flatten.join '&'
  end

  def to_params
    collect {|a| a.to_params }.flatten
  end
end

module OshparkHashExtensions
  def to_multipart key = nil
    collect {|k, v| v.to_multipart(key ? "#{key}[#{k}]" : k)}.flatten.compact
  end

  def to_query key = nil
    collect {|k, v| v.to_query(key ? "#{key}[#{k}]" : k)}.flatten.join '&'
  end

  def to_params
    self
  end
end

module OshparkStringExtensions
  def to_multipart key
    "Content-Disposition: form-data; name=\"#{key}\"\r\n\r\n" +
    "#{self}\r\n"
  end

  def to_query key = nil
    key ? URI.escape("#{key}=#{self}") : URI.escape(self)
  end
end

module OshparkFileExtensions
  def to_multipart key = nil
    "Content-Disposition: form-data; name=\"#{key}\"; filename=\"#{File.basename(self.path)}\"\r\n" +
    "Content-Transfer-Encoding: binary\r\n" +
    "Content-Type: application/#{File.extname(self.path)}\r\n\r\n" +
    "#{self.read}\r\n"
  end
end

module OshparkFixnumExtensions
  def to_query key = nil
    key ? URI.escape("#{key}=#{self}") : URI.escape(self)
  end
end

module OshparkFloatExtensions
  def to_query key = nil
    key ? URI.escape("#{key}=#{self}") : URI.escape(self)
  end
end

module OshparkTrueClassExtensions
  def to_multipart key
    "Content-Disposition: form-data; name=\"#{key}\"\r\n\r\n" +
    "1\r\n"
  end
end

module OshparkFalseClassExtensions
  def to_multipart key
    "Content-Disposition: form-data; name=\"#{key}\"\r\n\r\n" +
    "0\r\n"
  end
end

module OshparkNilClassExtensions
  def to_query key = nil
    ""
  end

  def to_multipart key = nil
    nil
  end
end

class Array
  include OshparkArrayExtensions
end

class Hash
  include OshparkHashExtensions
end

class String
  include OshparkStringExtensions
end

class File
  include OshparkFileExtensions
end

class Fixnum
  include OshparkFixnumExtensions
end

class Float
  include OshparkFloatExtensions
end

class TrueClass
  include OshparkTrueClassExtensions
end

class FalseClass
  include OshparkFalseClassExtensions
end

class NilClass
  include OshparkNilClassExtensions
end
