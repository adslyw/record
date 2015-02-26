$:.push File.expand_path("../lib", __FILE__)

# Maintain your gem's version:
require "record/version"

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  s.name        = "record"
  s.version     = Record::VERSION
  s.authors     = ["adslyw"]
  s.email       = ["adslyw@gmail.com"]
  s.homepage    = ""
  s.summary     = "Record gem is an oracle sql executor for my project."
  s.description = "Record gem is an oracle sql executor for my project."
  s.license     = "MIT"

  s.files = Dir["{app,config,db,lib}/**/*", "MIT-LICENSE", "Rakefile", "README.rdoc"]
  s.test_files = Dir["test/**/*"]

  s.add_dependency "rails", "~> 4.2.0"
  s.add_dependency "ruby-oci8", "~>2.1.7"
  s.add_development_dependency "sqlite3"
end
