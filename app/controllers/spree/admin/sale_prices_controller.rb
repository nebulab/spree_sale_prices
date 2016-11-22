module Spree
  module Admin
    class SalePricesController < BaseController
      respond_to :js, :html

      def index
        @sale_prices = resource.sale_prices
      end

      def create
        if product.present?
          @sale_price = product.put_on_sale params[:sale_price][:value], sale_price_params
        elsif sale_type_price.present?
          @sale_price = sale_type_price.put_on_sale(variant,
                                                    sale_type_price.value,
                                                    sale_type_price_attributes)
        else
          redirect_to request.referer
        end

        respond_with(@sale_price)
      end

      def destroy
        @sale_price = Spree::SalePrice.find(params[:id])
        @sale_price.destroy
        respond_with(@sale_price)
      end

      private

      def resource
        if product.present?
          product
        else
          sale_type_price
        end
      end

      def product
        @product = Spree::Product.find_by(slug: params[:product_id])
      end

      def sale_type_price
        @sale_type_price = Spree::SaleTypePrice.find_by(id: params[:sale_type_price_id])
      end

      def variant
        @variant = Spree::Variant.find_by id: params[:variant_id]
        redirect_to request.referer unless @variant.present?
        @variant
      end

      def sale_price_params
        params.require(:sale_price).permit(
          :id,
          :value,
          :currency,
          :start_at,
          :end_at,
          :enabled,
          :all_variants,
          :calculator
        )
      end

      def sale_type_price_attributes
        {
          all_variants:    false,
          calculator_type: sale_type_price.instance_calculator_type,
          start_at:        sale_type_price.start_at,
          enabled:         sale_type_price.enabled,
          end_at:          sale_type_price.end_at
        }
      end
    end
  end
end
