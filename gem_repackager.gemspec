# -*- encoding: utf-8 -*-

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
  gem.version       = '0.0.1'

  gem.add_development_dependency 'pry'
  gem.add_development_dependency 'rspec'
end
