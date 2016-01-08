# -*- encoding: utf-8 -*-
lib = File.expand_path('../lib', __FILE__)
require 'lib/zcommons/version'

Gem::Specification.new do |gem|
  gem.name          = "zcommons"
  gem.version       = Zcommons::VERSION
  gem.authors       = ["zhou huan"]
  gem.email         = ["towonzhou@gmail.com"]
  gem.description   = %q{常用小工具}
  gem.summary       = %q{常用小工具}
  gem.homepage      = ""

  gem.files         = `git ls-files`.split($/).map{|f| next if f =~ /^\.svn/;f }.delete_if{|f| f==nil}
  gem.executables   = gem.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.require_paths = ["lib"]
end
