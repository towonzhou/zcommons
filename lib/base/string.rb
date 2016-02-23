# -*- encoding : utf-8 -*-
require 'digest/md5'
require 'digest/sha2'
require 'iconv' if RUBY_VERSION < '1.9'
require 'zlib'

class String

  #md5摘要
  def md5
    Digest::MD5.hexdigest(self)
  end

  #sha2摘要
  # 参数:长度
  #  *256 default
  #  *385
  #  *512
  def sha2(bitlen=256)
    Digest::SHA2.new(bitlen).hexdigest(self)
  end

end
