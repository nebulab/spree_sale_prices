module Spree
  class SaleTypePrice < ActiveRecord::Base
    has_many :sale_prices

    def put_on_sale(object)
      object.put_on_sale(value, sale_type_price_attributes)
    end

    private

    def instance_calculator_type
      calculator_type.constantize.new
    end

    def sale_type_price_attributes
      {
        sale_type_price_id: id,
        calculator_type:    instance_calculator_type,
        all_variants:       false,
        start_at:           start_at,
        enabled:            enabled,
        end_at:             end_at
      }
    end
  end
end
