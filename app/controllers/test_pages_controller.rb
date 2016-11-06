class TestPagesController < ApplicationController
  def do_post
    params.permit!
    p = params[:payment]
    js = {
      org_code: p[:org_code],
      order_time: Time.now.strftime("%Y%m%d%H%M%S"),
      order_id: "TST" + Time.now.to_i.to_s,
      amount: p[:amount],
      order_title: p[:order_title],
      notify_url: AppConfig.get('pooul','notify_url') + "/test_notify",
      callback_url: AppConfig.get('pooul','callback_url') + "/test_callback",
      remote_ip: request.remote_ip
    }

    org = Org.find_by(org_code: p[:org_code])
    if org
      biz = Biz::PooulApi.new
      js[:mac] = biz.md5_mac(js, org.tmk)
      url = AppConfig.get('pooul', 'pay_url')
      if body_txt = Biz::WebBiz.post_data(url, {data: js.to_json}, nil)
        begin
          @js = JSON.parse(body_txt)
          @js.symbolize_keys!
        rescue => e
          @js = {error: e.message}
        end
      else
        @js = {error: 'post_data失败'}
      end
    else
      @js = {error: "org:[#{p[:org_code]}] not found!\n"}
    end
  end

  def gen_qrcode
    qr = RQRCode::QRCode.new("#{root_url}/test_pages/pay")
    qr.as_png.save("public/qrcodes/p001.png")
    qr = RQRCode::QRCode.new("#{root_url}/test_pages/pay_t1")
    qr.as_png.save("public/qrcodes/p002.png")
    qr = RQRCode::QRCode.new("#{root_url}/test_pages/pay_app_t0")
    qr.as_png.save("public/qrcodes/p003.png")
    qr = RQRCode::QRCode.new("#{root_url}/test_pages/pay_app_t1")
    qr.as_png.save("public/qrcodes/p004.png")
    qr = RQRCode::QRCode.new("#{root_url}/test_pages/pay_wap")
    qr.as_png.save("public/qrcodes/p005.png")
    render plain: 'gen_qrcode ok'
  end
end
