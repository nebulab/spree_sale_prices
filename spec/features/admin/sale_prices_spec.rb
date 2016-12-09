require 'spec_helper'

RSpec.feature 'Admin sale prices' do
  stub_authorization!

  let(:product) { create(:product) }

  context 'when listing sale prices' do
    before { product.put_on_sale(20.25) }

    scenario 'with the master variant the product sale is shown' do
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

  context 'when adding sale prices', js: true do
    scenario 'a new sale price is added to the list' do
      visit spree.admin_product_sale_prices_path(product_id: product.slug)

      fill_in('Amount', with: 32.33)
      fill_in('Sale Start Date', with: '2016/12/11 16:12')
      fill_in('Sale End Date', with: '2016/12/17 05:35 pm')
      click_button('Add Sale Price')

      within('[data-hook="products_row"]') do
        expect(page).to have_content(product.sku)
        expect(page).to have_content(32.33)

        within('.start-date') { expect(page).to have_content('December 11, 2016 4:12 PM') }
        within('.end-date') { expect(page).to have_content('December 17, 2016 5:35 PM') }
      end
    end

    context 'with multiple variants' do
      let!(:variants) { create_list(:variant, 3, product: product) }

      scenario 'a new sale price is added to the list' do
        visit spree.admin_product_sale_prices_path(product_id: product.slug)

        fill_in('Amount', with: 32.33)
        fill_in('Sale Start Date', with: '2016/12/11 16:12')
        fill_in('Sale End Date', with: '2016/12/17 05:35 pm')
        click_button('Add Sale Price')

        expect(page).to have_selector('[data-hook="products_row"]', count: 3)
      end

      scenario 'only certain variants are added if selected' do
        visit spree.admin_product_sale_prices_path(product_id: product.slug)

        fill_in('Amount', with: 32.33)
        fill_in('Sale Start Date', with: '2016/12/11 16:12')
        fill_in('Sale End Date', with: '2016/12/17 05:35 pm')
        select(variants.first.sku, from: 'Variants')
        select(variants.second.sku, from: 'Variants')
        click_button('Add Sale Price')

        expect(page).to have_selector('[data-hook="products_row"]', count: 2)
      end
    end
  end
end
