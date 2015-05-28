$LOAD_PATH.unshift File.expand_path(File.dirname(__FILE__)) + '/lib/'
require 'jackal-mail/version'
Gem::Specification.new do |s|
  s.name = 'jackal-mail'
  s.version = Jackal::Mail::VERSION.version
  s.summary = 'Jackal Mail'
  s.author = 'Chris Roberts'
  s.email = 'code@chrisroberts.org'
  s.license = 'Apache 2.0'
  s.homepage = 'http://github.com/carnivore-rb/jackal-mail'
  s.description = 'Jackal Mail'
  s.require_path = 'lib'
  s.add_dependency 'jackal'
  s.add_dependency 'pony'
  s.add_development_dependency 'carnivore-actor'

  s.files = Dir['**/*']
end
