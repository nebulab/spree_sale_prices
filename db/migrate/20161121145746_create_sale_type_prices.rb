class CreateSaleTypePrices < ActiveRecord::Migration
  def change
    create_table :spree_sale_type_prices do |t|
      t.string :name
      t.float :value
      t.string :calculator_type
      t.datetime :start_at
      t.datetime :end_at
      t.boolean :enabled
      t.timestamps
    end
  end
end
