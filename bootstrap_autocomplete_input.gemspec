$:.push File.expand_path("../lib", __FILE__)

# Maintain your gem's version:
require "bootstrap_autocomplete_input/version"

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  s.name        = "bootstrap_autocomplete_input"
  s.version     = BootstrapAutocompleteInput::VERSION
  s.authors     = ["Max Ivak"]
  s.email       = ["maxivak@gmail.com"]
  s.homepage    = "https://github.com/maxivak/bootstrap_autocomplete_input"
  s.summary     = "Autocomplete/typeahead input ready to be used with Bootstrap 4 in Rails 5. "
  s.description = "Adds an input with autocomplete/typeahead compatible with Bootstrap 4."
  s.license     = "MIT"


  s.files = Dir["{app,config,db,lib}/**/*", "MIT-LICENSE", "Rakefile", "README.rdoc"]
  s.test_files = Dir["test/**/*"]

  #
  s.add_development_dependency "rails", "~> 5.0"

  #
  s.add_development_dependency "sqlite3"
  s.add_development_dependency 'simple_form','~>3.1'
end
