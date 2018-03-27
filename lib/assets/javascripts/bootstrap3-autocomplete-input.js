var autocomplete_data_static = {};

function autocomplete_get_hidden_field(obj){
    var hidden_id = obj.attr("data-field-id");
    if (!hidden_id)
        return false;

    hidden_id = hidden_id.replace(/(:|\.|\[|\])/g,'\\$1');
    return $('#'+hidden_id);
}

function autocomplete_query(obj){
    obj.typeahead({
        source: function (q, process) {
            obj = this.$element;
            rows = [];

            var name = obj.attr('name');

            // load data from remote server
            $.getJSON( obj.attr('data-source-query'), {q: q},
                function( data ) {
                    autocomplete_data_static[name] = {"map":[], "values": []};

                    $.each(data, function (i, row) {
                        autocomplete_data_static[name]["values"].push(row[1]);
                        autocomplete_data_static[name]["map"][row[1]]=row[0];
                    });
                    process(autocomplete_data_static[name]["values"]);
                }
            );// get json
        }//source
        , updater: function (item) {
            obj = this.$element;

            // save the id value the hidden field
            var obj_id = autocomplete_get_hidden_field(obj);
            if (obj_id) {
                var name = obj.attr('name');
                obj_id.val(autocomplete_data_static[name]["map"][item]);
            }

            return item;
        }
        , items: obj.attr('data-items')
        , minLength: obj.attr('data-min-length')
        , afterSelect: function(item){
            var name = obj.attr('data-afterSelect') || '';
            if (name!='') {
                var fn = window[name];
                if (typeof(fn) == "function")
                    fn(item);
            }

        }
    }).on('change', function (e) {
        var obj = $(this);

        var current = obj.typeahead("getActive");

        // hidden field for id
        var obj_id = autocomplete_get_hidden_field(obj);
        if (obj_id) {
            if (current) {
                // Some item from your model is active!
                if (current == obj.val()) {
                    // This means the exact match is found. Use toLowerCase() if you want case insensitive match.

                    // the value is already set after select

                } else {
                    // This means it is only a partial match, you can either add a new item
                    // or take the active if you don't want new items
                    if (obj_id)
                        obj_id.val('');
                }
            } else {
                // Nothing is active so it is a new value (or maybe empty value)
                if (obj_id)
                    obj_id.val('');
            }
        }
    });// typeahead
}

function autocomplete_init(){

    // local array
    $( 'input[data-provide="typeahead"][data-source-array]' ).each(function() {
        obj = $(this);
        var arr = JSON.parse(obj.attr('data-source-array').replace(/&quot;/g, '"'));

        obj.typeahead({
            source: arr
            , items: obj.attr('data-items')
            , minLength: obj.attr('data-min-length')
        });//typeahead
    });


    // static data from server
    $( 'input[data-provide="typeahead"][data-source]' ).each(function() {
        obj = $(this);
        var name = obj.attr('id');
        autocomplete_data_static[name] = {"map":[], "values": []};

        $.get(obj.attr('data-source'), function(data){
            $.each(data, function (i, row) {
                autocomplete_data_static[name]["values"].push(row[1]);
                autocomplete_data_static[name]["map"][row[1]]=row[0];
            });

            obj.typeahead({
                source: autocomplete_data_static[name]["values"]
                , updater: function (item) {
                    // save the id value the hidden field
                    obj_id = $('#'+obj.attr("data-field-id"));
                    if (obj_id)
                        obj_id.val(autocomplete_data_static[name]["map"][item]);

                    return item;
                }
                , items: obj.attr('data-items')
                , minLength: obj.attr('data-min-length')
            });//typeahead
        },
        'json'
        );//get
    });


    // query data from server
    $('input[data-provide="typeahead"][data-source-query]').each(function() {
        autocomplete_query($(this));

    });// each

}