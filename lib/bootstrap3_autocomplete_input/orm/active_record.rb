module Bootstrap3AutocompleteInput
  module Orm
    module ActiveRecord
      def get_autocomplete_order(column_name, options, model=nil)
        order = options[:order]

        table_prefix = model ? "#{model.table_name}." : ""
        order || "#{table_prefix}#{column_name} ASC"
      end

      def get_autocomplete_items(parameters)
        model   = parameters[:model]
        term    = parameters[:q] || parameters[:term]


        options = parameters[:options]

        extra_columns = (options[:extra_columns] || []).map{|c| c.to_sym}
        #column_name  = options[:column_name]
        column_name = parameters[:method]

        #
        items = model.all
        unless options[:full_model]
          items = items.select(get_autocomplete_select_clause(model, column_name, extra_columns, options))
        end

        # basic where
        items = items.where(get_autocomplete_where_clause(model, term, column_name, options))


        # additional where
        scopes  = Array(options[:scopes])
        where   = options[:where]
        where_method   = options[:where_method]

        unless scopes.empty?
          scopes.each { |scope| items = items.send(scope) }
        end

        unless where.blank?
          items = items.where(where)
        end


        unless where_method.nil?
          if respond_to?(where_method)
            w = send(where_method)
            if w
              items = items.where(w)
            end
          end
        end


        # order, limit
        limit   = autocomplete_option_limit(options)
        order   = get_autocomplete_order(column_name, options, model)

        items = items.limit(limit).order(order)

        #
        items
      end

      def get_autocomplete_select_clause(model, column_name, extra_columns, options)
        table_name = model.table_name
        #cols = ([model.primary_key, column_name]+extra_columns).reject { |c| c.nil? || c.blank? || c.empty? }
        cols = ([model.primary_key, column_name]).reject { |c| c.nil? || c.blank? || c.empty? }

        #(["#{table_name}.#{model.primary_key}", "#{table_name}.#{column_name}"] + (options[:extra_data].blank? ? [] : options[:extra_data]))
        cols.map{|c| "#{table_name}.#{c}"} + (options[:extra_data].blank? ? [] : options[:extra_data])
      end

      def get_autocomplete_where_clause(model, term, column_name, options)
        table_name = model.table_name

        # basic search
        is_full_search = options[:full]
        like_clause = (postgres?(model) ? 'ILIKE' : 'LIKE')
        ["LOWER(#{table_name}.#{column_name}) #{like_clause} ?", "#{(is_full_search ? '%' : '')}#{term.downcase}%"]
      end

      def postgres?(model)
        # Figure out if this particular model uses the PostgreSQL adapter
        model.connection.class.to_s.match(/PostgreSQLAdapter/)
      end
    end
  end
end
