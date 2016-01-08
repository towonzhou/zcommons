# -*- encoding : utf-8 -*-
require 'digest/md5'
require 'digest/sha2'

#返回File的md5,sha2摘要
#File.open('/tmp/file'.md5
#File.open('/tmp/file').sha2(256)
class File
  #md5摘要
  def md5
    Digest::MD5.hexdigest(self.read)
  end

  #sha2摘要
  # 参数:长度
  #  *256 default
  #  *385
  #  *512
  def sha2(bitlen=256)
    Digest::SHA2.new(bitlen).hexdigest(self.read)
  end

end
