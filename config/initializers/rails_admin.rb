RailsAdmin.config do |config|

  ### Popular gems integration

  ##== Devise ==
  config.authenticate_with do
    warden.authenticate! scope: :user
  end
  config.current_user_method(&:current_user)
  config.total_columns_width = 1000
  config.default_items_per_page = 100

  ## == Cancan ==
  # config.authorize_with :cancan

  ## == Pundit ==
  # config.authorize_with :pundit

  ## == PaperTrail ==
  # config.audit_with :paper_trail, 'User', 'PaperTrail::Version' # PaperTrail >= 3.0.0

  ### More at https://github.com/sferik/rails_admin/wiki/Base-configuration

  ## == Gravatar integration ==
  ## To disable Gravatar integration in Navigation Bar set to false
  # config.show_gravatar true
  require 'i18n'

  config.main_app_name = Proc.new { |controller| [ "PooulGate", "管理后台 - #{controller.params[:action].try(:titleize)}" ] }
  I18n.default_locale = :"zh-CN"
  config.navigation_static_links = {
    '测试首页' => '/',
    '商户管理' => '/adm/orgs'
  }

  config.actions do
    dashboard                     # mandatory
    index                         # mandatory
    new
    export
    #bulk_delete
    show
    edit do
      only ['AppConfig', 'Org', 'Merchant', 'PfbMercht']
    end
    #delete
    #show_in_app


    ## With an audit adapter, you can add:
    # history_index
    # history_show
  end
  config.model 'Org' do
    navigation_label '系统管理'
    label '商户账号'
    edit do
      exclude_fields :d0_rate, :d0_min_fee, :t1_rate, :payments
    end
  end
  config.model 'User' do
    navigation_label '系统管理'
    label '管理用户'
  end
  config.model 'AppConfig' do
    navigation_label '系统管理'
    label '系统配置'
  end
  config.model 'ZxContrInfoList' do
    visible false
  end

end
