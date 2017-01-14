module BootstrapAutocompleteInput
  module Orm
    autoload :ActiveRecord , 'bootstrap_autocomplete_input/orm/active_record'
    autoload :Mongoid , 'bootstrap_autocomplete_input/orm/mongoid'
    autoload :MongoMapper , 'bootstrap_autocomplete_input/orm/mongo_mapper'
  end
end