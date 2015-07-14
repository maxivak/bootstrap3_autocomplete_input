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

            method = options[:column_name] if options.has_key?(:column_name)

            q = params[:q]

            class_name = options[:class_name] || object
            model = get_object(class_name)

            if q && q.present?
              items = get_autocomplete_items(:model => model, :options => options, :q => q, :method => method)
            elsif params[:q].nil?
              # return ALL
              items = get_autocomplete_items(:model => model, :options => options, :q => '', :method => method)
            end

            data = items_to_json(items, options[:display_value] ||= method)
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
      def items_to_json(items, method)
        items.collect do |item|
          v = item.send(method)
          [item.id.to_s, v.to_s]
        end
      end
    end

  end
end
