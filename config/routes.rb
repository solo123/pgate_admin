Rails.application.routes.draw do
  devise_for :users, :skip => [:registrations]

  resources :clients
  resources :admin_users
  resources :kf_gateways do
    member do
      get :sent_gateway, :show_post
    end
  end
  post 'recv_sm', to: 'recv_sm#recv_post'

  resources :jg_signins
  resources :recv_posts
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
