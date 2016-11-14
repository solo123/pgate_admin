class ZxMerchtsController < ApplicationController
  before_action :set_zx_mercht, only: [:show, :edit, :update, :destroy]

  # GET /zx_merchts
  # GET /zx_merchts.json
  def index
    @zx_merchts = ZxMercht.all
  end

  # GET /zx_merchts/1
  # GET /zx_merchts/1.json
  def show
  end

  # GET /zx_merchts/new
  def new
    @zx_mercht = ZxMercht.new
  end

  # GET /zx_merchts/1/edit
  def edit
  end

  # POST /zx_merchts
  # POST /zx_merchts.json
  def create
    @zx_mercht = ZxMercht.new(zx_mercht_params)

    respond_to do |format|
      if @zx_mercht.save
        format.html { redirect_to @zx_mercht, notice: 'Zx mercht was successfully created.' }
        format.json { render :show, status: :created, location: @zx_mercht }
      else
        format.html { render :new }
        format.json { render json: @zx_mercht.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /zx_merchts/1
  # PATCH/PUT /zx_merchts/1.json
  def update
    respond_to do |format|
      if @zx_mercht.update(zx_mercht_params)
        format.html { redirect_to @zx_mercht, notice: 'Zx mercht was successfully updated.' }
        format.json { render :show, status: :ok, location: @zx_mercht }
      else
        format.html { render :edit }
        format.json { render json: @zx_mercht.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /zx_merchts/1
  # DELETE /zx_merchts/1.json
  def destroy
    @zx_mercht.destroy
    respond_to do |format|
      format.html { redirect_to zx_merchts_url, notice: 'Zx mercht was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_zx_mercht
      @zx_mercht = ZxMercht.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def zx_mercht_params
      params.require(:zx_mercht).permit(:chnl_id, :chnl_mercht_id)
    end
end
