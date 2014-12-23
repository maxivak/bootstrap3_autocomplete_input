bootstrap3_autocomplete_input
=============================

Autocomplete/typeahead input ready to be used with Bootstrap 3 in Rails 4. 

Works with [SimpleForm](https://github.com/plataformatec/simple_form).

Adds an input with autocomplete/typeahead compatible with Bootstrap 3.

The gem uses the autocomplete library from [Bootstrap-3-Typeahead](https://github.com/bassjobsen/Bootstrap-3-Typeahead) that works with Bootstrap 3. With Twitter Bootstrap 3 the typeahead plugin had been dropped in favor to [Twitter's' typeahead.js](https://github.com/twitter/typeahead.js/) library. Twitter's typeahead doesn't work with Bootstrap 3 directly. For using autocomplete with jQuery autocomplete library in Rails 4, see the gem [rails4-autocomplete]( https://github.com/peterwillcn/rails4-autocomplete).


# Install

## Gemfile

```ruby

gem 'simple_form'
gem 'bootstrap3_autocomplete_input'

```

It assumes that you have Bootstrap 3 in your application. For example, you can use the [bootstrap-sass gem](https://github.com/twbs/bootstrap-sass).


## Javascript

run :install

```bash
run :install
```

This will copy js files 'bootstrap3-typeahead.min.js', 'bootstrap3-typeahead-input.min.js' to your assets.


include js files in your assets file 'app/assets/javascripts/application.js' after 'bootstrap.js'.

```bash
//= require jquery
//= require jquery_ujs
//= require turbolinks
//= require bootstrap
//= require bootstrap3-typeahead.min
//= require bootstrap3-typeahead-input

```


## CSS

All CSS for autocomplete input is already contained in Bootstrap 3 CSS.
  

For example, if you use bootstrap-sass, your css files 'app/assets/stylesheets/application.css.scss' might be

```bash  
@import "bootstrap-sprockets";
@import "bootstrap";
```




# Usage

Assuming that we have models Order and Client.

```ruby
class Order < ActiveRecord::Base
  belongs_to :client

end

class Client < ActiveRecord::Base
  has_many :orders

end

```


We will add autocomplete input to order's form for editing its client.


## controller

```ruby
class OrdersController < ApplicationController
   autocomplete :client, :name
   ...
end
```

This will generate the controller method 'autocomplete_client_name' that returns JSON data with clients.


## routes

Add routes for the generated controller action:

```ruby
resources :orders do
  get :autocomplete_client_name, :on => :collection
end
    
```

## view

### simple_form

use :autocomplete input type for the client's field in 'app/views/orders/_form.html.haml'

```ruby
=simple_form_for @order do |f|
    = f.error_notification

    = f.input :field1
    
    = f.input :client, :as => :autocomplete, :source_query => autocomplete_client_name_orders_url

    = f.button :submit, 'Save', :class=> 'btn-primary'
```



# Controller

Use in a controller:


This will add new action ''


It returns data in JSON format:
```text
[["id1", "name1"], ["id2", "name2"], ..]
```
which is an array of ids and titles.

Add a new route:

autocomplete_client_name_orders_url







# Options


## Data source

You have several options to get data for search:
 - :source => url - get static data downloaded from URL
 - :source_query => url - query data with a keyword from URL
 - :source_array => array - data is stored in local array of strings


examples:
```ruby

  = f.input :client, :as => :autocomplete, :source => autocomplete_client_name_orders_url
  
  = f.input :client, :as => :autocomplete, :source_query => autocomplete_client_name_orders_url
  
  = f.input :client, :as => :autocomplete, :source_array => ['item1', 'item2', ..]
```




## Object id

Autocomplete input adds a hidden field to use the id of the selected item.
Unless you use local array as data source (:source_array), the hidden field for the id is added automatically.

```ruby
  = f.input :client, :as => :autocomplete, :source_query => autocomplete_client_name_orders_url
```

This will generate HTML like
```html
<input id="order_client_id" type="hidden" value="0" name="order[client_id]">

<input id="order_client" name="order[client]"
class="autocomplete optional" type="text" value="*some value*" 
data-source-query="http://localhost:3000/orders/autocomplete_client_name" data-provide="typeahead" data-field-id="order_client_id" 
autocomplete="off">

```

This will update the field with id "order_client_id" with the id of the selected object. 

Data posted from the form to the server will contain the id of the selected client (params[:order][:client_id])
```text
params[:order]

{
client_id: 5,
client: 'client name',
...
}
```




If you don't want to have a hidden field for object id, set :field_id option to false:

```ruby
  = f.input :client, :as => :autocomplete, :source => autocomplete_client_name_orders_url, :field_id=>false
```

This will generate HTML without a hidden field:
```html
<input id="order_client" name="order[client]"
class="autocomplete optional" type="text" value="*value*" 
data-source="http://localhost:3000/orders/autocomplete_client_name" 
data-provide="typeahead" 
autocomplete="off">

```


## Input options

specify options:

```ruby
= simple_form_for @order do |f|

  = f.input :client, :as => :autocomplete, :source_query => autocomplete_client_name_orders_url, :option_name => opt_value, :option_name2=>value2

```

### :items

The max number of items to display in the dropdown. Default is 8.
```ruby
= simple_form_for @order do |f|

  = f.input :client, :as => :autocomplete, :source_query => autocomplete_client_name_orders_url, :items => 2

```



### :minLength
The minimum character length needed before triggering autocomplete suggestions. You can set it to 0 so suggestion are shown even when there is no text when lookup function is called. Default is 1.


```ruby
= simple_form_for @order do |f|

  = f.input :client, :as => :autocomplete, :source_query => autocomplete_client_name_orders_url, :minLength=>3

```



View the full list of options at https://github.com/bassjobsen/Bootstrap-3-Typeahead. Note that not all options from that list are supported by the current gem.




# Examples

## Static data from the server

```ruby
= simple_form_for @order, html: { autocomplete: 'off' } do |f|
  -#.. other fields..
  
  = f.input :client, :as => :autocomplete, :source => autocomplete_client_name_orders_url
  
```

Data will be loaded from the server once after page loads, and all queries to search a string will be against the stored data.
Do not use this if you have a big number of items for client.
    

## Query data from the server


```ruby
= f.input :client, :as => :autocomplete, :source_query => autocomplete_client_name_orders_url
```

Data will loaded from the server every time you type a new string in the field.



# Tests

# Development 

This gem uses the ORM library for ActiveRecord models included in [rails3-jquery-autocomplete](https://github.com/peterwillcn/rails4-autocomplete/tree/master/test/lib/rails3-jquery-autocomplete)


# TODO

Write tests




