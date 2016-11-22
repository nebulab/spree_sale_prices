class AddSaleTypePriceIdToSalePrice < ActiveRecord::Migration
  def change
    add_column :spree_sale_prices, :sale_type_price_id, :integer
  end
end
