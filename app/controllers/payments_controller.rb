class PaymentsController < ApplicationController
  before_action :set_payment, only: [:show, :edit, :update, :destroy]

  def sent_gateway
    set_payment
    p = @payment.dup
    p.parent_id = @payment.id
    p.service = 'wxgateway.wappay'
    p.version = '2.0'
    p.agency_id = 'DL109'
    p.trade_no = 'A' + ('%010d' % @payment.id)
    p.return_url = 'return.pooul.cn'
    p.notify_url = 'notify.pooul.cn'
    p.expire_minutes = 20
    @payment.status = 1
    p.save
    @payment.save
    redirect_to  action: :index
  end
  def show_post
    render text: 'abc!!'
  end

  # GET /payments
  # GET /payments.json
  def index
    @payments = Payment.all
  end

  # GET /payments/1
  # GET /payments/1.json
  def show
  end

  # GET /payments/new
  def new
    @payment = Payment.new
  end

  # GET /payments/1/edit
  def edit
  end

  # POST /payments
  # POST /payments.json
  def create
    @payment = Payment.new(payment_params)

    respond_to do |format|
      if @payment.save
        format.html { redirect_to @payment, notice: 'Payment was successfully created.' }
        format.json { render :show, status: :created, location: @payment }
      else
        format.html { render :new }
        format.json { render json: @payment.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /payments/1
  # PATCH/PUT /payments/1.json
  def update
    respond_to do |format|
      if @payment.update(payment_params)
        format.html { redirect_to @payment, notice: 'Payment was successfully updated.' }
        format.json { render :show, status: :ok, location: @payment }
      else
        format.html { render :edit }
        format.json { render json: @payment.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /payments/1
  # DELETE /payments/1.json
  def destroy
    @payment.destroy
    respond_to do |format|
      format.html { redirect_to payments_url, notice: 'Payment was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_payment
      @payment = Payment.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def payment_params
      params.require(:payment).permit(:service, :version, :agency_id, :trade_no, :fee, :return_url, :notify_url, :expire_minutes, :shop_id, :counter_id, :operator_id, :desc, :coupon_tag, :nonce_str, :sign)
    end
end
