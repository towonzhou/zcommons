# -*- encoding : utf-8 -*-
require 'digest/md5'
module Zcommons
  module Security
    module MD5
      def self.md5(s)
        return s if !s || s.empty?
        Digest::MD5.digest(s)
      end
    end
  end
end
