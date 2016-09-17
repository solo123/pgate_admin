class KaifuGatewaysController < ApplicationController
  before_action :set_kf_gateway, only: [:show, :edit, :update, :destroy]

  def sent_gateway
    set_kf_gateway
    p = @kf_gateway.dup
    p.parent_id = @kf_gateway.id
    p.send_time = Time.now.strftime("%Y%m%d%H%M%S")
    p.send_seq_id = "B2" + ('%010d' % @kf_gateway.id)
    p.trans_type = 'B001'
    p.organization_id = 'puerhanda'
    p.pay_pass = '1'
    p.notify_url = "http://112.74.184.236:8020/recv_posts"
    p.callback_url = "http://112.74.184.236:8020/recv_posts"
    p.mac = ''
    p.save
    @kf_gateway.status = 1
    @kf_gateway.save
    redirect_to  action: :index
  end
  def show_post
    set_kf_gateway
    s = "sendTime,sendSeqId,transType,organizationId,payPass,transAmt,fee,cardNo,name,idNum,body,notifyUrl,callbackUrl"
    pss = []
    pls = ''
    s.split(',').sort.each do |k|
      pls << @kf_gateway[k.underscore]
      pss << "'#{k}':'#{@kf_gateway[k.underscore]}'"
    end
    pls = pls + "9DB9095654D1FA7763F32E6B4E922140"
    pls = pls.force_encoding("UTF-8")

    mac = Digest::MD5.hexdigest(pls)
    pss << "'mac':'#{mac}'"

    s = post_to_server '{' + pss.join(',') + '}'

    puts "SHOW POST running -6------------"
    render plain: 'abc'
    return
  end

  def post_to_server(params_string)
    url = 'http://61.135.202.242/payform/organization_ymf'
    uri = URI(url)
    uri.query = URI.encode_www_form({data: params_string})

    dt = ''
    Net::HTTP.new(uri.host).start { |http|
      resp = http.get("#{uri.path}?#{uri.query.to_s}")
      dt = resp.body.to_s
      puts "========="
      puts params_string
      puts "========="
      puts resp.to_hash
      puts '----'
      puts "body=[#{dt}]"
    }
    return dt
  end
  def post1_to_server(params_string)
    url = 'http://61.135.202.242/payform/organization_ymf'
    para = {data: params_string}
    uri = URI(url)
    uri.query = URI.encode_www_form(para)
    #debugger


    url = 'http://61.135.202.242/payform/organization_ymf' + "?data=" + params_string
    return url
  end


  # GET /kf_gateways
  # GET /kf_gateways.json
  def index
    @kf_gateways = KfGateway.all
  end

  # GET /kf_gateways/1
  # GET /kf_gateways/1.json
  def show
  end

  # GET /kf_gateways/new
  def new
    @kf_gateway = KfGateway.new
  end

  # GET /kf_gateways/1/edit
  def edit
  end

  # POST /kf_gateways
  # POST /kf_gateways.json
  def create
    @kf_gateway = KfGateway.new(kf_gateway_params)

    respond_to do |format|
      if @kf_gateway.save
        format.html { redirect_to @kf_gateway, notice: 'Kf gateway was successfully created.' }
        format.json { render :show, status: :created, location: @kf_gateway }
      else
        format.html { render :new }
        format.json { render json: @kf_gateway.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /kf_gateways/1
  # PATCH/PUT /kf_gateways/1.json
  def update
    respond_to do |format|
      if @kf_gateway.update(kf_gateway_params)
        format.html { redirect_to @kf_gateway, notice: 'Kf gateway was successfully updated.' }
        format.json { render :show, status: :ok, location: @kf_gateway }
      else
        format.html { render :edit }
        format.json { render json: @kf_gateway.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /kf_gateways/1
  # DELETE /kf_gateways/1.json
  def destroy
    @kf_gateway.destroy
    respond_to do |format|
      format.html { redirect_to kf_gateways_url, notice: 'Kf gateway was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_kf_gateway
      @kf_gateway = KfGateway.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def kf_gateway_params
      params.require(:kf_gateway).permit(:parent_id, :send_time, :send_seq_id, :trans_type, :organization_id, :pay_pass, :img_url, :trans_amt, :fee, :card_no, :name, :id_num, :body, :notify_url, :callback_url, :resp_code, :resp_desc, :mac)
    end
end
