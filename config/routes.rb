Rails.application.routes.draw do
  require 'sidekiq/web'

  devise_for :users
  root to: "items#index"

  mount Sidekiq::Web => '/sidekiq'

  resources :items, only: [:index, :new, :create, :update, :show]
  resources :watches, only: [:index, :create, :update, :destroy]
  resources :coupons, only: [:index, :new, :create, :update, :destroy]

  resources :invoices, only: [:index, :show, :create] do
    member do
      post :close
    end
  end

  scope '/cart' do
    get "/" => "carts#show_cart", :as => "cart"
    get "/data" => "carts#data"
    post "/add-cart/:id" => "carts#add_cart", :as => "add_cart"
    delete "/remove-cart/:id" => "carts#remove_cart"

    scope '/code' do
      post "/:code" => "carts#add_code"
      delete "/:code" => "carts#delete_code"
    end
  end

end
