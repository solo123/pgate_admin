class PubController < ActionController::Base
  layout 'pub_app'
  protect_from_forgery with: :exception
end
