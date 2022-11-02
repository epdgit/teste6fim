Rails.application.routes.draw do
  devise_for :users
  root to: 'pages#home'
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
  post 'apostas', to: 'pages#apostas'
  get 'sorte', to: 'pages#sorte'
  get 'conjuntos', to: 'pages#conjuntos'
  # resources :sorteios

  get 'sorteios', to: 'sorteios#index'
  post 'sorteios', to: 'sorteios#create'
  get 'sorteios/new', to: 'sorteios#new'
  get 'sorteios/:id', to: 'sorteios#show', as: 'sorteio'
  get 'sorteios/:id/edit', to: 'sorteios#edit', as: 'edit_sorteio'
  patch 'sorteios/:id', to: 'sorteios#update'
  delete 'sorteios/:id', to: 'sorteios#destroy'

end
