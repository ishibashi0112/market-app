Rails.application.routes.draw do
  devise_for :users, :controllers => {
    omniauth_callbacks: 'users/omniauth_callbacks',
    registrations: 'users/registrations',
    sessions: 'users/sessions'
}

  devise_scope :user do
    get 'identifications', to: 'users/registrations#new_identification'
    post 'identifications', to: 'users/registrations#create_identification'
    get 'deliver_addresses', to: 'users/registrations#new_deliver_address'
    post 'deliver_addresses', to: 'users/registrations#create_deliver_address'
  end


  root 'items#index'
  resources :cards , only: [:index,:new,:create,:destroy] do 
    collection do
      post 'cards', to:'cards#add_card'
    end
    member do
      patch 'cards', to:'cards#change_default_card'
    end
  end
  resources :users 

  resources :items do
    resources :images
    member do
      get 'buy_check_page'
      post 'pay', to:'items#pay', as: 'pay'
    end
    collection do
      get 'index_more_new_page'
      get 'done_page'
      get 'get_category_children', defaults: { format: 'json' }
      get 'get_category_grandchildren', defaults: { format: 'json' }
      get 'update_done'
    end
  end
  resources :users do
    member do
      get 'index_seller_page'
      get 'index_buyer_page'
    end
  end
end
