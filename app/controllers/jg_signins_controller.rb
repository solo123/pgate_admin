class JgSigninsController < ApplicationController
  before_action :set_jg_signin, only: [:show, :edit, :update, :destroy]

  # GET /jg_signins
  # GET /jg_signins.json
  def index
    @jg_signins = JgSignin.all
  end

  # GET /jg_signins/1
  # GET /jg_signins/1.json
  def show
  end

  # GET /jg_signins/new
  def new
    @jg_signin = JgSignin.new
  end

  # GET /jg_signins/1/edit
  def edit
  end

  # POST /jg_signins
  # POST /jg_signins.json
  def create
    @jg_signin = JgSignin.new(jg_signin_params)

    respond_to do |format|
      if @jg_signin.save
        format.html { redirect_to @jg_signin, notice: 'Jg signin was successfully created.' }
        format.json { render :show, status: :created, location: @jg_signin }
      else
        format.html { render :new }
        format.json { render json: @jg_signin.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /jg_signins/1
  # PATCH/PUT /jg_signins/1.json
  def update
    respond_to do |format|
      if @jg_signin.update(jg_signin_params)
        format.html { redirect_to @jg_signin, notice: 'Jg signin was successfully updated.' }
        format.json { render :show, status: :ok, location: @jg_signin }
      else
        format.html { render :edit }
        format.json { render json: @jg_signin.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /jg_signins/1
  # DELETE /jg_signins/1.json
  def destroy
    @jg_signin.destroy
    respond_to do |format|
      format.html { redirect_to jg_signins_url, notice: 'Jg signin was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_jg_signin
      @jg_signin = JgSignin.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def jg_signin_params
      params.require(:jg_signin).permit(:result_text, :terminal_info)
    end
end
