class RecvPostsController < ApplicationController
  # For APIs, you may want to use :null_session instead.
  #protect_from_forgery with: :null_session
  skip_before_action :verify_authenticity_token

  before_action :set_recv_post, only: [:show, :edit, :update, :destroy]

  # GET /recv_posts
  # GET /recv_posts.json
  def index
    @recv_posts = RecvPost.all
  end

  # GET /recv_posts/1
  # GET /recv_posts/1.json
  def show
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_recv_post
      @recv_post = RecvPost.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def recv_post_params
      params.require(:recv_post).permit(:remote_host, :header, :body)
    end
end
