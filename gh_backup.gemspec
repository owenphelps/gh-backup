# -*- encoding: utf-8 -*-
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'gh_backup/version'

Gem::Specification.new do |gem|
  gem.name          = "gh_backup"
  gem.version       = GhBackup::VERSION
  gem.authors       = ["owain lewis"]
  gem.email         = ["owain@owainlewis.com"]
  gem.description   = %q{ Backups up github repos }
  gem.summary       = %q{ Gem that backups up repos for an organization }
  gem.homepage      = ""

  gem.files         = `git ls-files`.split($/)
  gem.executables   = gem.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.require_paths = ["lib"]
  
  gem.add_runtime_dependency "thor" 
  gem.add_runtime_dependency "rake"
end
