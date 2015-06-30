class AutocompleteInput < SimpleForm::Inputs::TextInput
  #enable :placeholder, :maxlength

  def input(wrapper_options = nil)
    out = ActiveSupport::SafeBuffer.new

    # prepare options
    new_html_options = merge_wrapper_options(prepare_html_options, wrapper_options)


    # hidden field
    if add_field_id?
      hidden_name = "#{attribute_name}_id"
      hidden_id = "#{object_name}_#{attribute_name}_id"
      new_html_options["data-field-id"] ||= hidden_id

      hidden_options = {}
      hidden_options[:id] = hidden_id

      # value
      value_method = "#{attribute_name}_id"
      if new_html_options.has_key?(:value)
        v = new_html_options[:value]
      elsif object.respond_to?(value_method)
        v = object.send(value_method)
      end
      hidden_options[:value] = v unless v.nil?

      out << @builder.hidden_field(hidden_name, hidden_options)
    end

    #
    new_html_options[:value] = options[:value_text] unless options[:value_text].nil?

    out << @builder.text_field(attribute_name, new_html_options)
    out
  end

  def prepare_html_options
    new_options = {}

    new_options[:class] = [input_html_options[:class], options[:class]].compact

    #
    new_options["data-provide"] ||= "typeahead"
    new_options["autocomplete"] ||= "off"

    # source
    if options[:source]
      new_options["data-source"] = options[:source]
    elsif options[:source_query]
      new_options["data-source-query"] = options[:source_query]
    elsif options[:source_array]
      #new_options["data-source-array"] = options[:source_array].inspect.to_s # problem with quotes "
      new_options["data-source-array"] = '['+options[:source_array].map{|r| "&quot;#{r}&quot;"}.join(',')+']'
    end


    # data options
    new_options["data-items"] = options[:items] || 8
    new_options["data-min-length"] = options[:minLength] || 1
    new_options["data-afterSelect"] = options[:afterSelect] || false

    # value
    new_options[:value] = options[:value] unless options[:value].nil?
    new_options[:value_text] = options[:value_text] unless options[:value_text].nil?


    input_html_options.merge new_options
  end

  def add_field_id?
    !options[:source_array] && (options[:field_id].nil? || options[:field_id])
  end
end

