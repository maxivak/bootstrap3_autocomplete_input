console.log("init0");

var autocomplete_data_static = {};

$(document).ready(function() {
    console.log("init");

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
        obj = $(this);

        obj.typeahead({
            source: function (q, process) {
                obj = this.$element;
                rows = [];

                var name = obj.attr('name');
                autocomplete_data_static[name] = {"map":[], "values": []};

                // load data from remote server
                $.getJSON( obj.attr('data-source-query'), {q: q},
                    function( data ) {
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
                var name = obj.attr('name');
                // save the id value the hidden field
                obj_id = $('#'+obj.attr("data-field-id"));
                if (obj_id)
                    obj_id.val(autocomplete_data_static[name]["map"][item]);

                return item;
            }
            , items: obj.attr('data-items')
            , minLength: obj.attr('data-min-length')
        });// typeahead
    });// each

});