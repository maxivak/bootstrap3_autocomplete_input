module Bootstrap3AutocompleteInput
  #
  require 'bootstrap3_autocomplete_input/rails/engine'
end

# orm
require 'bootstrap3_autocomplete_input/orm'



# extend controller
require 'bootstrap3_autocomplete_input/controllers/autocomplete'

class ActionController::Base
  include Bootstrap3AutocompleteInput::Controllers::Autocomplete
end

# simple_form
begin
  require 'simple_form'
  require 'bootstrap3_autocomplete_input/simple_form_inputs'

rescue LoadError
end