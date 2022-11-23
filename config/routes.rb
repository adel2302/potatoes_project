Rails.application.routes.draw do
  get 'stock_prices/search'
  get 'stock_prices/simulation'
 post 'wallets', to: 'wallets#create'
 post '/users', to: 'users#create'
 post '/login', to: 'authentication#login'
end
