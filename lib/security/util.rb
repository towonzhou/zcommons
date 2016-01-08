# -*- encoding : utf-8 -*-
# include Zcommons::Security::Util
require 'cgi'
module Zcommons
  module Security
    module Util
      #= 生成密码工具
      # 根据指定参数生成随机码形式密码
      #参数:
      # :lenght => 长度默认8
      # :base => 10 默认0-9,可选26 a-z;36 0-9 a-z;52 a-z A-Z;62 0-9 a-z A-Z

      def generate_password(p={:lenght => 8 ,:base => 10})
        lenght = p[:lenght] || 8
        base = p[:base].to_i || 10
        base = 10 if base <=0 || base > 62
        lenght = 8 if lenght <= 0
        base_codes = []
        rs = ""
        case base
        when 10 then
          base_codes = ("0".."9").to_a
        when 26 then
          base_codes = ("a".."z").to_a
        when 36 then
          base_codes.concat(("0".."9").to_a).concat(("a".."z").to_a)
        when 52 then
          base_codes.concat(("a".."z").to_a).concat(("A".."A").to_a)
        when 62 then
          base_codes.concat(("0".."9").to_a).concat(("a".."z").to_a).concat(("A".."Z").to_a)
        end
        lenght.times{|i|
          rs << base_codes[rand(base_codes.size.to_i)]
        }
        rs
      end #generate_password

      #= 对 hash 进行排序和串接

      #= 对数据进行签名
      # 接收要签名的数据，根据一定的规则进行签名
      #参数:
      # :sign_type => 'MD5'...
      # :data => 要签名的数据,如data是hash，转换出来的字符串为 key=value
      # :sort => nil,asc,desc 数据排序方法，如果传入的数据是数组或hash,可以对数组或hash进行排序,默认 asc,如这个参数是 nil 则不进行排序
      # :sort_by => key,value 如果传入的数据是 hash,则根据本参数指定的key或value进行排序,默认是key
      # :sort_seq => 特定排序方法，如本参数存在，将忽略上述 sort 参数,如要签名数据是hash,且未指定sort_by,默认是key
      # :split_by => 如data是数组或hash,签名时候转换字符串，分割的字符
      # :hash_split_by => '=' 如data是hash，转换出来的字符串为 key=value
      # :skip_empty_value = true 是否跳过空值,仅data是hash时候支持
      # :cgi_escape => false 是否对数据中的值进行cgi_escapt,默认false,仅当data为hash时有效
      # :ex_value => 扩展数据，在排序完成后(如需要),将这个参数的数据以一定规则串成字符串后直接添加到排序好的数据后
      # :skip_key_values => [] 进行签名时，忽略本参数设定的键值对,仅当data为hash时有效


      def hash_sort(*args)
        data_sort_and_sign(*args,true)
      end

      def data_sign(*args)
        data_sort_and_sign(*args,false)
      end

      def data_sort_and_sign(*args,only_sort)
        sign_type = :MD5
        data = nil
        sort = :asc
        sort_by = :key
        sort_seq = nil
        split_by = ''
        cgi_escape = false
        ex_value = nil
        hash_split_by = '='
        skip_empty_value = false
        skip_key_values = []
        args.each{|arg|
          arg.map{|k,v|
            case k.to_sym
            when :sign_type then sign_type = v
            when :data then data = v
            when :sort then sort = v.to_sym
            when :sort_by then sort_by = v.to_sym
            when :sort_seq then sort_seq = v
            when :split_by then split_by = v
            when :hash_split_by then hash_split_by = v
            when :cgi_escape then cgi_escape = v
            when :ex_value then ex_value = v
            when :skip_empty_value then skip_empty_value = v
            when :skip_key_values then skip_key_values = v
            end
          }
        }

        #根据排序规则进行排序
        if data.is_a?(Hash)
          if sort_seq.is_a?(Array) #如果有特定排序顺序，且data是hash
            _s = []
            sort_seq.each{|ss| _s << [ ss.to_sym , data[ss.to_sym] ] }
            data = _s
          else
            if sort == :asc
              data =  (sort_by == :key) ? data.sort_by{|k,v| k.to_s} : data.sort_by{|k,v| v.to_s}
            elsif sort == :desc
              data =  (sort_by == :key) ? data.sort_by{|k,v| k.to_s}.reverse : data.sort_by{|k,v| v.to_s}.reverse
            end
          end
          _s = []
          data.each{|d|
            k = d[0] if d[0]
            v = d[1] if d[1]
            next if skip_empty_value == true &&  v.to_s.empty?
            next if skip_key_values.include?(k)
            v = CGI::escape(v.to_s) if cgi_escape == true
            _s << %Q~#{k}#{hash_split_by}#{v}~
          }
          data = _s.join(split_by)
        elsif data.is_a?(Array)
          data = (sort == :asc) ? data.sort : data.reverse
          data = data.join(split_by)
        end

        data = "#{data}#{ex_value}" unless ex_value.to_s.empty?
        return data if only_sort
        case sign_type.to_sym
        when :MD5 then data.to_s.md5
        end
      end #data_sign

    end #Util
  end #Security
end #Zcommons
