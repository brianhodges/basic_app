class BASICLib
  def self.random_string(len, prefix='')
    s = SecureRandom.base64 len
    s.gsub!(/\W/, 'x')
    prefix + s
  end
end