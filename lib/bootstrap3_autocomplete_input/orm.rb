module Bootstrap3AutocompleteInput
  module Orm
    autoload :ActiveRecord , 'bootstrap3_autocomplete_input/orm/active_record'
    autoload :Mongoid , 'bootstrap3_autocomplete_input/orm/mongoid'
    autoload :MongoMapper , 'bootstrap3_autocomplete_input/orm/mongo_mapper'
  end
end