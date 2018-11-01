Rails.application.routes.draw do
  get 'home', to: 'home#index'
  root 'home#index'

  post 'home', to: 'home#login'
  post 'home/email', to: 'home#email'
  get 'home/:id/setup', to: 'home#setup'
  post 'home/setup', to: 'home#setup_account'
  post 'home/register', to: 'home#register'
  get 'home/:id/forget', to: 'home#forget_password'
  get 'home/:id/genkey', to: 'home#keygen'

  get 'home/verify', to: 'home#verify'
  post 'home/verify', to: 'home#verify'

  get 'home/result', to: 'home#result'
  get 'home/result/download', to: 'home#download'
  get 'home/result/:id', to:'home#result'

  get 'organize', to: 'organize#home'
  get 'organize/logout', to: 'organize#logout'
  post 'organize/change_password', to: 'organize#change_password'

  post 'organize/add', to: 'organize#add'
  get 'organize/:menu/search/:name', to: 'organize#search'
  get 'organize/:menu/:user_id/:other_id', to: 'organize#get_data'
  post 'organize/alter', to: 'organize#alter'
  post 'organize/discard', to: 'organize#discard'

  get 'voter', to: 'voter#home'
  get 'voter/logout', to: 'voter#logout'

  get 'vote/:id', to: 'voter#get_candidate'
  post 'vote', to: 'voter#vote'
  post 'vote/verify', to: 'voter#verify'
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
