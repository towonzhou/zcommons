# encoding: UTF-8

module Zcommons
  module Security
    require 'openssl'
    class Des
      class << self
        #加密
        #参数
        # key 16进制密钥
        # plaintext 明文
        # alg 算法
        # padding 是否使用 padding
        def encrypt(key,plaintext,alg='des',padding=0)
          des_encrypt_decrypt(key,plaintext,'enc',alg,padding)
        end

        #解密
        #参数
        # key 16进制密钥
        # decrypt_data 密文
        # alg 算法
        # padding 是否使用 padding
        def decrypt(key,decrypt_data,alg='des',padding=0)
          des_encrypt_decrypt(key,decrypt_data,'dec',alg,padding)
        end

        private
        def des_encrypt_decrypt(key,data,act='enc',alg='des',padding=0)
          des = OpenSSL::Cipher::Cipher.new(alg)
          des.padding = padding
          OpenSSL.errors if OpenSSL.errors
          act== 'enc' ? des.encrypt : des.decrypt
          des.key = key
          res = des.update(data)
          res << des.final
          return res
        end
      end
    end
  end
end
