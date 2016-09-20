class ClientPaymentsController < ResourcesController

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

end
