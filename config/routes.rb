Rails.application.routes.draw do
  get 'guests/new'
  resources :participants
  resources :guests
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
  get 'basic-qr-code-reader', to: 'basic_qr_codes#index'
  post 'attendance', to: 'attendance#add_attendance'
  root to: "guests#new"

  resources :qr_codes, only: [:new, :create, :show]
end
