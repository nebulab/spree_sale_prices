Spree::Core::Engine.routes.draw do
  namespace :admin do
    resources :products, only: [] do
      resources :sale_prices
    end
    resources :sale_type_prices
  end
end
