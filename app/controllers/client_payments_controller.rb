class ClientPaymentsController < ResourcesController
  def statement
    @collection = ClientPayment.where(status: 8).show_order\
      .page(params[:page]).per(100)
  end
  def send_notify
    @object = ClientPayment.find(params[:id])
    Biz::PaymentBiz.send_notify(@object)
  end

end
