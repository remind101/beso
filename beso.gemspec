# -*- encoding: utf-8 -*-
require File.expand_path('../lib/beso/version', __FILE__)

Gem::Specification.new do |gem|
  gem.authors       = ["Jeremy Ruppel"]
  gem.email         = ["jeremy.ruppel@gmail.com"]
  gem.description   = %q{Sync your KISSmetrics history, guapo!}
  gem.summary       = %q{Sync your KISSmetrics history, guapo!}
  gem.homepage      = "https://github.com/remind101/beso"

  gem.files         = `git ls-files -x -i *.rb`.split($\)
  gem.executables   = gem.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.name          = "beso"
  gem.require_paths = ["lib"]
  gem.version       = Beso::VERSION

  gem.add_dependency 'rails', '>= 3.0.10'
  # gem.add_dependency 'fastercsv', '>= 1.5.4'
  gem.add_dependency 'fog', '>= 1.3.1'

  gem.add_development_dependency 'sqlite3'
  gem.add_development_dependency 'appraisal', '>= 0.4.1'
  gem.add_development_dependency 'approvals', '>= 0.0.4'
  gem.add_development_dependency 'rspec-rails', '>= 2.10.1'
end
