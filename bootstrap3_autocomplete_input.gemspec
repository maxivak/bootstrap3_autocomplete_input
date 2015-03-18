$:.push File.expand_path("../lib", __FILE__)

# Maintain your gem's version:
require "bootstrap3_autocomplete_input/version"

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  s.name        = "bootstrap3_autocomplete_input"
  s.version     = Bootstrap3AutocompleteInput::VERSION
  s.authors     = ["Max Ivak"]
  s.email       = ["maxivak@gmail.com"]
  s.homepage    = "https://github.com/maxivak/bootstrap3_autocomplete_input"
  s.summary     = "Autocomplete/typeahead input ready to be used with Bootstrap 3 in Rails 4. "
  s.description = "Adds an input with autocomplete/typeahead compatible with Bootstrap 3."
  s.license     = "MIT"


  s.files = Dir["{app,config,db,lib}/**/*", "MIT-LICENSE", "Rakefile", "README.rdoc"]
  s.test_files = Dir["test/**/*"]

  #
  s.add_development_dependency "rails", "~> 4.1"

  #
  s.add_development_dependency "sqlite3"
  s.add_development_dependency 'simple_form','~>3.1'
end
