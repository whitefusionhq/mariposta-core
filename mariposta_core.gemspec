$:.push File.expand_path("../lib", __FILE__)

# Maintain your gem's version:
require "mariposta_core/version"

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  s.name        = "mariposta_core"
  s.version     = MaripostaCore::VERSION
  s.authors     = ["Jared White"]
  s.email       = ["jared@jaredwhite.com"]
  s.homepage    = "https://www.mariposta.com"
  s.summary     = "Summary of MaripostaCore."
  s.description = "Description of MaripostaCore."
  s.license     = "Copyright 2016 WHITEFUSION. All Rights Reserved"

  all_files       = `git ls-files -z`.split("\x0")
  s.files         = all_files.grep(%r{^(exe|lib)/|^.rubocop.yml$})

  s.add_dependency "rails", ">= 5.0", "< 6.0"
  s.add_dependency 'safe_yaml', '~> 1.0'

  s.add_development_dependency "rspec-rails", "3.5"
end
