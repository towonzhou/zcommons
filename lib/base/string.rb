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

  #转驼峰
  def camelize
    return self.gsub(/\/(.?)/) { "::" + $1.upcase }.gsub(/(^|_)(.)/) { $2.upcase }
  end

  def uncamelize
    w = self.dup
    w.gsub!(/::/,'/')
    w.scan(/([A-Z])/){ w = w.gsub($1,"_"+$1.downcase)}
    w.gsub!(/^\_/,'')
    return w
  end


  #去除前后空格的方法别名
  def trim
    self.strip
  end

  #遮盖字符
  #如字符串长度大于10默认是显示全部字符的前3后4
  #其余字符以 * 显示
  #用法
  # "1112312312312".cover(:mark=>'*',:prefix => 3,:suffix => 4)
  def cover(opts = {} )
    return self if !self || self.empty?
    opts = case
    when self.size >= 20 then {:prefix => 5,:suffix => 8,:mark => '*'}.merge(opts)
    when self.size >= 11 then {:prefix => 3,:suffix => 4,:mark => '*'}.merge(opts)
    when self.size >= 8 then {:prefix => 2,:suffix => 2,:mark => '*'}.merge(opts)
    end
    ta = self.split(//)
    m = opts[:mark] * (self.size - opts[:prefix] - opts[:suffix])
    "#{ta[0,opts[:prefix]]}#{m}#{ta[0-opts[:suffix],self.size]}"
  end

  #对原有ljust的扩展
  # 参数:
  #   len 补位长度
  def ex_ljust(len,pdastr='',opts={})
    ex_encode(opts).ljust(len,pdastr)
  end

  #对原有ljust的扩展
  def ex_rjust(len,pdastr='',opts={})
    ex_encode(opts).rjust(len,pdastr)
  end

  #字符串编码转换
  # 用法:
  # p "a啊".ljust(10,'_')
  # p "a啊".ex_ljust(10,'_',:binary => true)
  # p "a啊".rjust(10,'_')
  # p "a啊".ex_rjust(10,'_',:binary => true)
  #
  def ex_encode(opts={})
    default_opts = {:from => 'UTF-8',:to => 'UTF-8',:binary => false}
    opts = default_opts.merge(opts)

    return self if (opts.fetch(:from) === opts.fetch(:to)) && opts.fetch(:binary) === false
    return [self].pack('a*') if (opts.fetch(:from) === opts.fetch(:to)) && opts.fetch(:binary) === true

    if RUBY_VERSION < '1.9'
      ts = Iconv.iconv(opts.fetch(:to),opts.fetch(:from),self).to_s
    else
      ts = self.encode(opts.fetch(:to),opts.fetch(:from))
    end
    opts.fetch(:binary) === true ? [ts].pack('a*') : ts
  end

  #转换成16进制字符串
  #"你好".to_hex # => e4bda0e5a5bd
  def to_hex
    self.unpack('H*').join
  end

  #将16进制字符串转换
  #puts "e4bda0e5a5bd".from_hex # => 你好
  def from_hex
    [self].pack('H*')
  end

  #"你好".to_base64 # => 5L2g5aW9
  def to_base64
    [self].pack('m*').gsub("\n",'')
  end

  #puts "5L2g5aW9".from_base64
  #你好
  def from_base64
    self.unpack('m*').join
  end

  #字符串压缩
  def compress(level=9)
    z = Zlib::Deflate.new(level)
    dst = z.deflate(self, Zlib::FINISH)
    z.close
    dst
  end

  #字符串解压
  def decompress
    zstream = Zlib::Inflate.new
    buf = zstream.inflate(self)
    zstream.finish
    zstream.close
    buf
  end

  #版本号转换
  # 2.11.10 = 10 * 10 + 11 * 100 + 2 * 1000
  #结果就是上述的总和,数值越大，版本越新
  def version_mark
    return 0 unless self
    ic = 0
    self.split(/\./).reverse.inject(0){|result,m| result +  (m.to_i * 10 ** ic+=1).to_i}
  end

end
