module Backend
  class BackendController < ActionController::Base
    layout 'backend'
    protect_from_forgery with: :exception
    before_action :authenticate_user!
  end
end
