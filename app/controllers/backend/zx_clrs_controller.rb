class Backend::ZxClrsController < ResourcesController
  def create
    biz = Biz::ZxIntfcApi.new(nil)
    biz.send_zx_clr(params[:clr_dt])
    flash[:error] = biz.err_desc unless biz.err_code == '00'

    redirect_to action: :index
  end

  def update
  end
end
