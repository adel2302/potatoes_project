Rails.application.routes.draw do
 post 'wallets', to: 'wallets#create'
 post '/users', to: 'users#create'
 post '/login', to: 'authentication#login'
end
