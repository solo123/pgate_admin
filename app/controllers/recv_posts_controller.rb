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

  # GET /recv_posts/new
  def new
    @recv_post = RecvPost.new
  end

  # GET /recv_posts/1/edit
  def edit
  end

  # POST /recv_posts
  # POST /recv_posts.json
  def create
    @recv_post = RecvPost.new
    @recv_post.remote_host = request.remote_ip()
    @recv_post.header =
%{
CONTENT_TYPE : "#{request.headers['CONTENT_TYPE']}"
CONTENT_LENGTH : "#{request.headers['CONTENT_LENGTH']}"
}
    @recv_post.body = params.to_s
    @recv_post.save
    redirect_to @recv_post, notice: 'Recv post was successfully created.'
  end

  # PATCH/PUT /recv_posts/1
  # PATCH/PUT /recv_posts/1.json
  def update
    respond_to do |format|
      if @recv_post.update(recv_post_params)
        format.html { redirect_to @recv_post, notice: 'Recv post was successfully updated.' }
        format.json { render :show, status: :ok, location: @recv_post }
      else
        format.html { render :edit }
        format.json { render json: @recv_post.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /recv_posts/1
  # DELETE /recv_posts/1.json
  def destroy
    @recv_post.destroy
    respond_to do |format|
      format.html { redirect_to recv_posts_url, notice: 'Recv post was successfully destroyed.' }
      format.json { head :no_content }
    end
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
