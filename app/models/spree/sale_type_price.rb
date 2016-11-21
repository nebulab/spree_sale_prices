module Spree
  class SaleTypePrice < ActiveRecord::Base
    has_many :sale_prices
  end
end
