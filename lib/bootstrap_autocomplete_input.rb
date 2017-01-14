module BootstrapAutocompleteInput
  #
  require 'bootstrap_autocomplete_input/rails/engine'
end

# orm
require 'bootstrap_autocomplete_input/orm'



# extend controller
require 'bootstrap_autocomplete_input/controllers/autocomplete'

class ActionController::Base
  include BootstrapAutocompleteInput::Controllers::Autocomplete
end

# simple_form
begin
  require 'simple_form'
  require 'bootstrap_autocomplete_input/simple_form_inputs'

rescue LoadError
end