Rails.application.routes.draw do
  resources :participants
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
  get 'basic-qr-code-reader', to: 'basic_qr_codes#index'

  resources :qr_codes, only: [:new, :create, :show]
end
