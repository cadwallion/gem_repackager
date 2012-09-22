# -*- encoding: utf-8 -*-

require File.expand_path('../lib/gem_repackager/version', __FILE__)

Gem::Specification.new do |gem|
  gem.authors       = ["Andrew Nordman"]
  gem.email         = ["cadwallion@gmail.com"]
  gem.description   = %q{Repackage your installed gems}
  gem.summary       = %q{Repackage installed gems into .gem files}
  gem.homepage      = ""

  gem.files         = `git ls-files`.split($\)
  gem.executables   = gem.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.name          = "gem_repackager"
  gem.require_paths = ["lib"]
  gem.version       = Gem::Repackager::VERSION

  gem.add_development_dependency 'pry'
  gem.add_development_dependency 'rspec'
  gem.add_development_dependency 'rake'
end
