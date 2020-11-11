Rails.application.routes.draw do
  resources :post_codes, only: [:index]
end
