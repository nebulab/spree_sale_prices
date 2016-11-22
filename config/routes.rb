Spree::Core::Engine.routes.draw do
  namespace :admin do
    resources :products, only: [] do
      resources :sale_prices
    end

    resources :sale_type_prices do
      member do
        get :sale_prices
      end

      resources :sale_prices, only: [:create, :destroy]
    end
  end
end
