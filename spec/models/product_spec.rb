require 'spec_helper'

describe Spree::Product do
  let(:product) { create(:product) }

  describe '#put_on_sale' do
    it 'can put a product on sale' do
      expect(product.price).to eql 19.99
      expect(product.original_price).to eql 19.99
      expect(product.on_sale?).to be false

      product.put_on_sale 10.95

      expect(product.price).to eql 10.95
      expect(product.original_price).to eql 19.99
      expect(product.on_sale?).to be true
    end

    context 'with variants' do
      let!(:variants) { create_list(:variant, 3, product: product) }
      let(:first) { variants.first }
      let(:second) { variants.second }
      let(:last) { variants.last }

      context 'with selected variants' do
        it 'can put specific variants on sale' do
          product.put_on_sale(10.95, {}, [first.id, last.id])

          expect(first.price).to eql 10.95
          expect(first.original_price).to eql 19.99
          expect(first.on_sale?).to be true

          expect(second.price).to eql 19.99
          expect(second.original_price).to eql 19.99
          expect(second.on_sale?).to be false

          expect(last.price).to eql 10.95
          expect(last.original_price).to eql 19.99
          expect(last.on_sale?).to be true
        end

        it 'can set all variants on sale' do
          product.put_on_sale(10.95, {}, [])

          expect(first.price).to eql 10.95
          expect(first.original_price).to eql 19.99
          expect(first.on_sale?).to be true

          expect(second.price).to eql 10.95
          expect(second.original_price).to eql 19.99
          expect(second.on_sale?).to be true

          expect(last.price).to eql 10.95
          expect(last.original_price).to eql 19.99
          expect(last.on_sale?).to be true
        end
      end
    end
  end
end
