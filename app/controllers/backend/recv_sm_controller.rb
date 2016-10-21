class Backend::RecvSmController < ApplicationController
  skip_before_action :verify_authenticity_token

  def recv_post
    @recv_post = RecvPost.new
    @recv_post.remote_host = request.remote_ip()
    @recv_post.header =
%{
CONTENT_TYPE : "#{request.headers['CONTENT_TYPE']}"
CONTENT_LENGTH : "#{request.headers['CONTENT_LENGTH']}"
}
    @recv_post.body = params.to_s
    @recv_post.save
    render text: 'true'
  end
end
