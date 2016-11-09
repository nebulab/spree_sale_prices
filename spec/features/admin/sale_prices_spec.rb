require 'spec_helper'

RSpec.feature 'Admin sale prices' do
  stub_authorization!

  let(:product) { create(:product) }

  before { product.put_on_sale(20.25) }

  scenario 'on a product with just the master only the product sale is shown' do
    visit spree.admin_product_sale_prices_path(product_id: product.slug)

    expect(page).to have_selector('[data-hook="products_row"]', count: 1)

    within('[data-hook="products_row"]:first') do
      expect(page).to have_content(product.sku)
    end
  end

  context 'with multiple variants' do
    let(:variants) { create_list(:variant, 2, product: product) }

    before do
      variants.first.put_on_sale(10.95)
      variants.last.put_on_sale(11.95)
    end

    scenario 'a list of variant sale prices is shown expect the master' do
      visit spree.admin_product_sale_prices_path(product_id: product.slug)

      expect(page).to have_selector('[data-hook="products_row"]', count: 2)

      within('[data-hook="products_row"]:first') do
        expect(page).to have_content(variants.first.sku)
      end

      within('[data-hook="products_row"]:last') do
        expect(page).to have_content(variants.last.sku)
      end
    end
  end
end
