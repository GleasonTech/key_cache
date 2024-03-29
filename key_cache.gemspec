$:.push File.expand_path('../lib', __FILE__)

require 'key_cache/version'

Gem::Specification.new do |s|
  s.name        = 'key_cache'
  s.version     = KeyCache::VERSION
  s.authors     = ['Nicholas W. Watson', "Joe D'Arcangelo"]
  s.email       = 'joe.darcangelo@gleasontech.com'
  s.summary     = 'KeyCache ties in to ActiveRecord callbacks and enables you to store info in redis'
  s.description = 'KeyCache ties in to ActiveRecord callbacks and enables you to store info in redis'

  s.files = Dir['{lib}/**/*', 'README.md']
  s.homepage    = 'https://github.com/joedarc/key_cache'
  s.license     = 'MIT'

  s.add_development_dependency 'rails', '>= 4.0'

  s.add_dependency 'activerecord', '>= 4.0'
  s.add_dependency 'activesupport', '>= 4.0'
end
