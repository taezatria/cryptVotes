Rails.application.routes.draw do
  get 'home', to: 'home#index'
  root 'home#index'
  post 'home', to: 'home#login'
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
