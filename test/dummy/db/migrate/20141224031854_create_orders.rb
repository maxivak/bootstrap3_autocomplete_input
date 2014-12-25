class CreateOrders < ActiveRecord::Migration
  def change
    create_table :orders do |t|

      t.string :notes
      t.string :product_name


      t.timestamps
    end
  end
end
