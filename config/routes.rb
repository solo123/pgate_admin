Rails.application.routes.draw do
  resources :app_configs
  devise_for :users, :skip => [:registrations]

  resources :clients
  resources :admin_users
  resources :client_payments, only: [:index, :show]
  resources :recv_posts, only: [:index, :show] do
    collection do
      get :send_all_notifies
    end
  end
  get 'test_pages/:action', to: 'test_pages#%(action)'
  post 'test_pages', to: 'test_pages#do_post'

  post 'recv_sm', to: 'recv_sm#recv_post'
  resources :kaifu_gateways
  resources :kaifu_results

  resources :kaifu_signins, only: [:index]
  root 'home#index'
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

  get ':controller/:action/(:id)'
end
