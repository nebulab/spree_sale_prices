require 'spec_helper'

RSpec.feature 'Admin sale type prices' do
  stub_authorization!

  let(:product) { create(:product) }

  let(:sale_type_price) { create(:sale_type_price, value: 20.25) }

  let(:sale_type_price_url) do
    spree.admin_sale_type_price_sale_prices_path(sale_type_price_id: sale_type_price.id)
  end

  context 'with multiple variants' do
    let(:variants) { create_list(:variant, 2, product: product) }

    before do
      sale_type_price.put_on_sale variants.first
      sale_type_price.put_on_sale variants.last
    end

    scenario 'a list of variant sale prices is shown expect the master' do
      visit sale_type_price_url

      expect(page).to have_selector('[data-hook="sale_type_prices_row"]', count: 2)

      within('[data-hook="sale_type_prices_row"]:first') do
        expect(page).to have_content(variants.first.sku)
      end

      within('[data-hook="sale_type_prices_row"]:last') do
        expect(page).to have_content(variants.last.sku)
      end
    end
  end
end
