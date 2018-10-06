Rails.application.routes.draw do
  get 'home', to: 'home#index'
  root 'home#index'
  post 'home', to: 'home#login'
  post 'home/email', to: 'home#email'
  post 'home/register', to: 'home#register'
  get 'home/:id/setup', to: 'home#setup'
  post 'home/setup', to: 'home#setup_account'

  get 'organize', to: 'organize#dashboard'
  get 'organize/logout', to: 'organize#logout'
  post 'organize/change_password', to: 'organize#change_password'
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
