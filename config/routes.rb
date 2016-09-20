Rails.application.routes.draw do
  devise_for :users, :skip => [:registrations]

  resources :clients
  resources :admin_users
  resources :client_payments, only: [:index, :show]
  resources :recv_posts, only: [:index, :show]
  get 'test_pages/:action', to: 'test_pages#%(action)'
  post 'test_pages', to: 'test_pages#do_post'

  post 'recv_sm', to: 'recv_sm#recv_post'
  resources :kaifu_gateways do
    member do
      get :sent_gateway, :show_post
    end
  end

  resources :jg_signins
  resources :jgp_b001s do
    member do
      get :sent_gateway, :show_post
    end
  end
  root 'home#index'
  get 'home/index'
  put 'wgate', to: 'wgate#payment'

  resources :payments do
    member do
      get :sent_gateway, :show_post
    end
  end

  resources :jgps do
    collection do
      get :signin
    end
  end
end
