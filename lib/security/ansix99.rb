# encoding: UTF-8
# Ansix99 算法
module Zcommons
  module Security
    $:.unshift "#{File.expand_path File.join(File.dirname(__FILE__))}"
    require 'openssl'
    require 'des'
    class Ansix99
      attr_accessor :hmac
      def initialize(key,body)
        return '' if !body || body.empty?
        return '' if !key || key.empty?
        a1 = Array.new(8,0)
        pa = body.each_byte.to_a
        while pa.size > 0
          pg = pa.shift(8).to_a
          while pg.size < 8 ; pg.push(0); end
          a1 = Des.encrypt(key,[8.times.map{|i| a1[i].ord^pg[i].ord}.map{|c| sprintf('%02x',c) }.join].pack('H*'))
        end
        @hmac ||= a1.unpack('H*').join.upcase
      end
    end
  end
end


if $0 == __FILE__
  include Zcommons::Security
  #key,plain_text
  #key   4字节
  #key = 'ABCD'.unpack('H*').join
  str = "8371|4006b841-3181-4637-9753-839534975785|9667|123456ABC|9137"
  key = '12FE98AC'
  puts Ansix99.new(key,str).hmac
end
