require 'spec_helper'

RSpec.feature 'Admin sale prices' do
  stub_authorization!

  let(:product) { create(:product) }
  let(:small) do
    create(:variant, product: product,
                     option_values: [create(:option_value, presentation: 'S')])
  end
  let(:medium) do
    create(:variant, product: product,
                     option_values: [create(:option_value, presentation: 'M')])
  end
  let(:large) do
    create(:variant, product: product,
                     option_values: [create(:option_value, presentation: 'L')])
  end

  context 'when listing sale prices' do
    before { product.put_on_sale(20.25) }

    scenario 'with the master variant the product sale is shown' do
      visit spree.admin_product_sale_prices_path(product_id: product.slug)

      expect(page).to have_selector('[data-hook="products_row"]', count: 1)
      expect(page).not_to have_selector('.variant_sales_picker')

      within('[data-hook="products_row"]:first') do
        expect(page).to have_content(product.name)
      end
    end

    context 'with multiple variants' do
      before do
        small.put_on_sale(10.95, start_at: 5.days.from_now)
        medium.put_on_sale(11.95, start_at: 10.days.from_now)
        large.put_on_sale(32.21)
      end

      scenario 'a list of variant sale prices is shown and sorted by start_at' do
        visit spree.admin_product_sale_prices_path(product_id: product.slug)

        expect(page).to have_selector('[data-hook="products_row"]', count: 4)

        within('[data-hook="products_row"]:first') do
          expect(page).to have_content(product.name)
        end

        within('[data-hook="products_row"]:nth-child(2)') do
          expect(page).to have_content(large.options_text)
        end

        within('[data-hook="products_row"]:nth-child(3)') do
          expect(page).to have_content(small.options_text)
        end

        within('[data-hook="products_row"]:last') do
          expect(page).to have_content(medium.options_text)
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
        expect(page).to have_content(product.name)
        expect(page).to have_content(32.33)

        within('.start-date') { expect(page).to have_content('December 11, 2016 4:12 PM') }
        within('.end-date') { expect(page).to have_content('December 17, 2016 5:35 PM') }
      end
    end

    context 'with multiple variants' do
      before { small; medium; large }

      scenario 'a new sale price is added to the list' do
        visit spree.admin_product_sale_prices_path(product_id: product.slug)

        fill_in('Amount', with: 32.33)
        fill_in('Sale Start Date', with: '2016/12/11 16:12')
        fill_in('Sale End Date', with: '2016/12/17 05:35 pm')
        click_button('Add Sale Price')

        expect(page).to have_selector('[data-hook="products_row"]', count: 4)
      end

      scenario 'only certain variants are added if selected' do
        visit spree.admin_product_sale_prices_path(product_id: product.slug)

        fill_in('Amount', with: 32.33)
        fill_in('Sale Start Date', with: '2016/12/11 16:12')
        fill_in('Sale End Date', with: '2016/12/17 05:35 pm')
        select(product.name, from: 'Variants')
        select(small.options_text, from: 'Variants')
        select(medium.options_text, from: 'Variants')
        click_button('Add Sale Price')
        expect(page).to have_selector('[data-hook="products_row"]', count: 3)
      end
    end
  end
end
