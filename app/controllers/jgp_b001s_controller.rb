class JgpB001sController < ApplicationController
  before_action :set_jgp_b001, only: [:show, :edit, :update, :destroy]

  def sent_gateway
    set_jgp_b001
    p = @jgp_b001.dup
    p.parent_id = @jgp_b001.id
    p.send_time = Time.now.strftime("%Y%m%d%H%M%S")
    p.send_seq_id = "b1" + ('%010d' % @jgp_b001.id)
    p.trans_type = 'B001'
    p.organization_id = 'puerhanda'
    p.pay_pass = '1'
    p.trans_amt = @jgp_b001.trans_amt
    p.fee = @jgp_b001.fee
    p.card_no = @jgp_b001.card_no
    p.name = @jgp_b001.name
    p.id_num = @jgp_b001.id_num
    p.body = @jgp_b001.body
    p.notify_url = "http://112.74.184.236:8010/recv_posts"
    p.mac = ''
    p.save
    @jgp_b001.status = 1
    @jgp_b001.save
    redirect_to  action: :index
  end
  def show_post
    set_jgp_b001
    s = "sendTime,sendSeqId,transType,organizationId,payPass,transAmt,fee,cardNo,name,idNum,body,notifyUrl"
    ps = []
    pss = []
    pls = ''
    s.split(',').sort.each do |k|
      pls << @jgp_b001[k.underscore].to_s.force_encoding("UTF-8")
      pss << "'#{k}':'#{@jgp_b001[k.underscore]}'"
    end
    mac = Digest::MD5.hexdigest(pls + 'ABC10BC2E402622FC4B083C3FA9E6747')
    pss << "'mac':'#{mac}'"

    s = post_to_server '{' + pss.join(',') + '}'
    render plain: s + "\n" + pss.join(',')
  end

  def post_to_server(params_string)
    url = 'http://61.135.202.242:8020/payform/organization?data=' + URI.encode(params_string)
    return url
  end
  def post2_to_server(params_string)
    url = 'http://61.135.202.242:8020/payform/organization?data=' + (params_string)
    uri = URI(url)
    res = Net::HTTP.post_form(uri, data: params_string)
    result_txt = res.body
    return result_txt
end

  def post1_to_server(params_string)
    url = 'http://61.135.202.242:8020/payform/organization'
    uri = URI(url)
    uri.query = URI.encode_www_form({data: params_string})
    res = Net::HTTP.get_response(uri)
    debugger
    return 'post ok'
  end

  
  # GET /jgp_b001s
  # GET /jgp_b001s.json
  def index
    @jgp_b001s = JgpB001.all
  end

  # GET /jgp_b001s/1
  # GET /jgp_b001s/1.json
  def show
  end

  # GET /jgp_b001s/new
  def new
    @jgp_b001 = JgpB001.new
  end

  # GET /jgp_b001s/1/edit
  def edit
  end

  # POST /jgp_b001s
  # POST /jgp_b001s.json
  def create
    @jgp_b001 = JgpB001.new(jgp_b001_params)

    respond_to do |format|
      if @jgp_b001.save
        format.html { redirect_to @jgp_b001, notice: 'Jgp b001 was successfully created.' }
        format.json { render :show, status: :created, location: @jgp_b001 }
      else
        format.html { render :new }
        format.json { render json: @jgp_b001.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /jgp_b001s/1
  # PATCH/PUT /jgp_b001s/1.json
  def update
    respond_to do |format|
      if @jgp_b001.update(jgp_b001_params)
        format.html { redirect_to @jgp_b001, notice: 'Jgp b001 was successfully updated.' }
        format.json { render :show, status: :ok, location: @jgp_b001 }
      else
        format.html { render :edit }
        format.json { render json: @jgp_b001.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /jgp_b001s/1
  # DELETE /jgp_b001s/1.json
  def destroy
    @jgp_b001.destroy
    respond_to do |format|
      format.html { redirect_to jgp_b001s_url, notice: 'Jgp b001 was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_jgp_b001
      @jgp_b001 = JgpB001.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def jgp_b001_params
      params.require(:jgp_b001).permit(:send_time, :send_seq_id, :trans_type, :organization_id, :pay_pass, :img_url, :trans_amt, :fee, :card_no, :name, :id_num, :body, :notify_url, :resp_code, :resp_desc, :mac, :status)
    end
end
