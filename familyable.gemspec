$:.push File.expand_path("../lib", __FILE__)

# Maintain your gem's version:
require "familyable/version"

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  s.name = "familyable"
  s.version = Familyable::VERSION
  s.authors = ["Brook Williams"]
  s.email = ["brook.williams@gmail.com"]
  s.homepage = "http://stickandlogdesigns.com"
  s.summary = "A gem for creating self-referential parent child relationships on a model"
  s.description = "A gem for creating self-referential parent child relationships on a model"

  s.files = Dir["{app,config,db,lib}/**/*", "MIT-LICENSE", "Rakefile", "README.md"]

  s.add_dependency "rails", ['>= 4.0', '< 5.1']
  s.add_development_dependency "pg"
  s.add_development_dependency "rspec-rails"
end
