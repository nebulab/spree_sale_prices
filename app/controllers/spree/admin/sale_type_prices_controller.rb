module Spree
  module Admin
    class SaleTypePricesController < ResourceController
      respond_to :js, :html

      before_action :calculators_type, only: [:new, :edit]

      private

      def calculators_type
        @calculators = [
          'Spree::Calculator::PercentOffSalePriceCalculator',
          'Spree::Calculator::FixedAmountSalePriceCalculator'
        ]
      end

      def permit_attributes
        params.require(:sale_type_price).permit([:name, :start_at, :end_at,
                                                 :value, :calculator_type])
      end
    end
  end
end
