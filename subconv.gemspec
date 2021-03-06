# -*- encoding: utf-8 -*-

$LOAD_PATH.push File.expand_path('../lib', __FILE__)
require 'subconv/version'

Gem::Specification.new do |s|
  s.name                   = 'subconv'
  s.version                = Subconv::VERSION
  s.platform               = Gem::Platform::RUBY
  s.required_ruby_version  = '>=1.9'
  s.author                 = 'Miłosz Jerkiewicz'
  s.email                  = 'sncf@users.noreply.github.com'
  s.date                   = '2014-09-16'
  s.summary                = 'Subtitle converter'
  s.description            = 'Subtitle converter. Can convert XML timed text to MicroDVD and SRT.'
  s.homepage               = 'https://github.com/sncf/subconv'
  s.license                = 'MIT'
  s.files                  = `git ls-files`.split("\n")
  s.require_paths          = ['lib']
  s.add_runtime_dependency   'nokogiri', '~>0'
  s.test_files             = `git ls-files -- test/*`.split("\n")
  s.executables            = `git ls-files -- bin/*`.split("\n").map { |f| File.basename(f) }
  s.has_rdoc               = false
end
