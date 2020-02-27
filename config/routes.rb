Rails.application.routes.draw do
  devise_for :users, controllers:{
    registrations: 'users/registrations',
  }
  root to: 'items#index'
  resources :users
  resources :items do


    member do
      get :order 
    end
    resources :messages, only:[:create, :new]
    resources :orders, only:[:new, :create, :edit ,:update ,:destroy]
      collection do
        get 'index', to: 'orders#index'
        post 'pay', to: 'orders#pay'
        get 'done', to: 'orders#done'
      end
  end

  # resources :cards 
  resources :cards, only: [:new, :show] do
    collection do
      post 'show', to: 'cards#show'
      post 'pay', to: 'cards#pay'
      post 'delete', to: 'cards#delete'
    end

  end


end
 