# -*- encoding : utf-8 -*-
require 'openssl'
require 'base64'
require 'cgi'

#对大数据进行RSA加密

module Zcommons
  module Security
    class LargeDataRsa
      def initialize(keyfile_path,keysize = 1024)
        @private_key = OpenSSL::PKey::RSA.new(File.read(keyfile_path))
        @keysize = keysize
      end

      def private_encrypt(plain_data)
        ds = []
        public_key = @private_key.public_key
        split_plain_data(plain_data){|chunk|
          ds << @private_key.private_encrypt(chunk)
        }
        CGI::escape(Base64.encode64(ds.join).gsub(/\n/,''))
      end

      def public_decrypt(encrypt_data)
        public_key = @private_key.public_key
        eds = Base64.decode64(CGI::unescape(encrypt_data))
        rs = []
        split_plain_data(eds,'decrypt'){|chunk|
          rs << public_key.public_decrypt(chunk)
        }
        rs.join
      end

      private
        #对明文进行分块
        def split_plain_data(data,mode='encrypt')
          len = mode == 'encrypt' ? @keysize/8-11 : @keysize/8
          plain_bytes = data.each_byte.map{|c| c}
          while plain_bytes.size > 0
            yield plain_bytes.shift(len).map{|c| c.chr}.join
          end
        end #end def split_plain_data
    end
  end
end
