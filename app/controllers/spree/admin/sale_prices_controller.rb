module Spree
  module Admin
    class SalePricesController < BaseController

      before_filter :load_product

      respond_to :js, :html

      def index
        @sale_prices = Spree::SalePrice.for_product(@product)
      end

      def create
        @sale_price = @product.put_on_sale(params[:sale_price][:value],
                                           sale_price_params, selected_variant_ids)

        @sale_prices = Spree::SalePrice.for_product(@product)
        respond_with(@sale_price)
      end

      def edit
        @sale_price = Spree::SalePrice.find(params[:id])
      end

      def update
        Spree::SalePrice.destroy(params[:id])
        @sale_price = @product.put_on_sale(params[:sale_price][:value],
                                           sale_price_params, selected_variant_ids)

        @sale_prices = Spree::SalePrice.for_product(@product)
        respond_with(@sale_price)
      end

      def destroy
        @sale_price = Spree::SalePrice.find(params[:id])
        @sale_price.destroy
        respond_with(@sale_price)
      end

      private

      def load_product
        @product = Spree::Product.find_by(slug: params[:product_id])
        redirect_to request.referer unless @product.present?
      end

      def selected_variant_ids
        params.fetch(:variant_ids, [])
      end

      def sale_price_params
        params.require(:sale_price).permit(
            :id,
            :value,
            :currency,
            :start_at,
            :end_at,
            :enabled
        )
      end
    end
  end
end
