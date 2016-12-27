Rails.application.routes.draw do
  mount RailsAdmin::Engine => '/admin', as: 'rails_admin'
  devise_for :users, :skip => [:registrations]

  scope module: :backend, path: :adm do
    root to: 'orgs#index'
    resources :app_configs
    resources :orgs do
      member do
        get :create_sub_mct, :send_to_zx, :create_merchant
      end
    end
    resources :sent_posts, :notify_recvs
    resources :merchants
    resources :zx_mcts, :zx_clrs
    resources :sub_mcts
  end

  namespace :test_pages do
    %w(gen_qrcode pay pay_t1 pay_app_t0 pay_app_t1 pay_wap query_openid random_string).each do |action|
      get action, action: action
    end
  end
  post 'test_pages', to: 'test_pages#do_post'
  post 'recv_sm', to: 'recv_sm#recv_post'
  root 'home#index'

end
