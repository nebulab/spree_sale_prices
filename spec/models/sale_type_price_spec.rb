require 'spec_helper'

describe Spree::SaleTypePrice do
  describe ".put_on_sale" do
    let(:sale_type_price) { create(:active_sale_type_price, value: 10.95) }
    let(:variant) { create(:product).master }

    it "put on sale variant" do
      expect(variant.price).to eql 19.99
      expect(variant.original_price).to eql 19.99
      expect(variant.on_sale?).to be false

      sale_type_price.put_on_sale(variant)

      expect(variant.price).to eql 10.95
      expect(variant.original_price).to eql 19.99
      expect(variant.on_sale?).to be true
    end
  end
end
