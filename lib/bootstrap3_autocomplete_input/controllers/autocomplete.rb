#require 'orm/active_record'

module Bootstrap3AutocompleteInput
  module Controllers

    module Autocomplete
      def self.included(target)
        target.extend Bootstrap3AutocompleteInput::Controllers::Autocomplete::ClassMethods

        if defined?(Mongoid::Document)
          target.send :include, Bootstrap3AutocompleteInput::Orm::Mongoid
        elsif defined?(MongoMapper::Document)
          target.send :include, Bootstrap3AutocompleteInput::Orm::MongoMapper
        else
          target.send :include, Bootstrap3AutocompleteInput::Orm::ActiveRecord
        end
      end


      module ClassMethods

        def autocomplete(object, method, options = {})
          define_method("autocomplete_#{object}_#{method}") do
            # model
            class_name = options[:class_name] || object
            model = get_object(class_name)

            term = '' # return ALL
            q = params[:q]
            q = '' if q.nil?

            #
            items = get_autocomplete_items(:model => model, :method=>method, :options => options, :q => q)

            #
            method_display_value = options[:display_value] if options.has_key?(:display_value)
            method_display_value ||= method

            method_display_id = options[:display_id] if options.has_key?(:display_id)
            method_display_id ||= model.primary_key

            data = items_to_json(items, method_display_id, method_display_value)
            render :json => data.to_json
          end
        end
      end


      def autocomplete_option_limit(options)
        options[:limit] ||= 10
      end


      # Returns parameter model_sym as a constant
      def get_object(model_sym)
        object = model_sym.to_s.camelize.constantize
      end

      #
      # Returns an array of [id, name]
      #
      def items_to_json(items, method_display_id, method_display_value)
        items.collect do |item|
          v = item.send(method_display_value)
          id = item.send(method_display_id)

          [id.to_s, v.to_s]
        end
      end
    end

  end
end
