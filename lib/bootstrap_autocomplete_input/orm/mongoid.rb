module BootstrapAutocompleteInput
  module Orm
    module Mongoid
      def get_autocomplete_order(method, options, model=nil)
        order = options[:order]
        if order
          order.split(',').collect do |fields|
            sfields = fields.split
            [sfields[0].downcase.to_sym, sfields[1].downcase.to_sym]
          end
        else
          [[method.to_sym, :asc]]
        end
      end

      def get_autocomplete_items(parameters)
        model          = parameters[:model]
        method         = parameters[:method]
        options        = parameters[:options]
        scopes         = options[:scopes]
        is_full_search = options[:full]
        term           = parameters[:term]
        limit          = autocomplete_option_limit(options)
        order          = get_autocomplete_order(method, options)

        if is_full_search
          search = '.*' + Regexp.escape(term) + '.*'
        else
          search = '^' + Regexp.escape(term)
        end

        items = model.where(method.to_sym => /#{search}/i).limit(limit).order_by(order)

        case scopes
          when Symbol then
            items = items.send(scopes)
          when Array then
            scopes.each { |scope| items = items.send(scope) } unless scopes.empty?
        end
        items
      end
    end
  end
end
