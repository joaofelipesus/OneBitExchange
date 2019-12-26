Rails.application.routes.draw do
  # root 'exchanges/index', to: 'exchanges#index'
  # get 'exchanges/convert', to: 'exchanges#convert'
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  root 'exchanges#index'
  get 'convert', to: 'exchanges#convert'
end
