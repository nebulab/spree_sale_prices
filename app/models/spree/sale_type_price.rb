module Spree
  class SaleTypePrice < ActiveRecord::Base
    has_many :sale_prices

    def instance_calculator_type
      calculator_type.constantize.new
    end

    def put_on_sale(object, value, params = {})
      params[:sale_type_price_id] = id
      object.put_on_sale(value, params)
    end
  end
end
