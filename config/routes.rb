Rails.application.routes.draw do
  get 'stock_prices/search'
  get 'stock_prices/simulation'
 post '/users', to: 'users#create'
 post '/login', to: 'authentication#login'
 post 'orders', to: 'orders#create'
end
