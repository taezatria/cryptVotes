Rails.application.routes.draw do
  get 'home', to: 'home#index'
  root 'home#index'

  post 'home', to: 'home#login'
  post 'home/email', to: 'home#email'
  get 'home/:id/setup/:str', to: 'home#setup'
  post 'home/setup', to: 'home#setup_account' #!
  post 'home/register', to: 'home#register'

  get 'home/:id/forget/:str', to: 'home#forget_password'
  post 'home/forget', to: 'home#forget_password' #!
  get 'home/:id/genkey/:str', to: 'home#keygen'
  post 'home/genkey', to: 'home#keygen' #!

  get 'home/verify', to: 'home#verify'
  post 'home/verify', to: 'home#verify'

  get 'home/result', to: 'home#result'
  get 'home/result/download', to: 'home#download'
  get 'home/result/:id', to:'home#result'

  get 'organize', to: 'organize#home'
  get 'organize/logout', to: 'organize#logout'
  post 'organize/change_password', to: 'organize#change_password' #!

  post 'organize/add', to: 'organize#add' #!
  post 'organize/addbyfile', to: 'organize#add_by_file' #!
  post 'organize/tally/:id', to: 'organize#tally'
  post 'organize/anounce/:id', to: 'organize#anounce'
  post 'organize/verifyemail', to: 'organize#verifyemail'
  post 'organize/election/:id/:staction', to: 'organize#handle_election'
  post 'organize/alter', to: 'organize#alter' #!
  post 'organize/discard', to: 'organize#discard' #!
  get 'organize/result/:id/download', to: 'organize#download'
  get 'organize/:menu/search/:name', to: 'organize#search_by_name'
  get 'organize/:menu/searchid/:idnumber', to: 'organize#search_by_idnumber'
  get 'organize/:menu/filter/:election_id', to: 'organize#filter_by_election'
  get 'organize/:menu/:user_id/:other_id', to: 'organize#get_data'

  get 'voter', to: 'voter#home'
  get 'voter/logout', to: 'voter#logout'
  get 'voter/result/:id/download', to: 'voter#download'

  get 'vote/:id', to: 'voter#get_candidate'
  post 'vote', to: 'voter#vote' #!
  post 'vote/verify', to: 'voter#verify'
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
