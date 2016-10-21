Rails.application.routes.draw do

  mount RailsAdmin::Engine => '/admin', as: 'rails_admin'
  devise_for :users, :skip => [:registrations]

  scope module: :backend, path: :adm do
    root to: 'client_payments#index'
    resources :app_configs
    resources :clients, :post_dats, :biz_errors
    resources :tfb_orders
    resources :admin_users
    resources :kaifu_gateways
    resources :kaifu_results
    resources :kaifu_signins, only: [:index]
    resources :client_payments, only: [:index, :show] do
      member do
        get :send_notify
      end
      collection do
        get :statement
      end
    end
    resources :recv_posts, only: [:index, :show] do
      collection do
        get :send_all_notifies
      end
    end
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

  namespace :test_pages do
    %w(gen_qrcode pay pay_t1 pay_app_t0 pay_app_t1 pay_wap query_openid).each do |action|
      get action, action: action
    end
  end
  post 'test_pages', to: 'test_pages#do_post'
  post 'recv_sm', to: 'recv_sm#recv_post'
  root 'home#index'
  put 'wgate', to: 'wgate#payment'

end
