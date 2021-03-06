#require 'securerandom'

class TestPagesController < ApplicationController
  protect_from_forgery except: :random_string

  def do_post
    params.permit!
    p = params[:payment].select { |_, value| !value.empty? }
    order_num = "TST" + Time.now.to_i.to_s
    js_biz = {
      order_time: Time.now.strftime("%Y%m%d%H%M%S"),
      order_num: order_num,
      amount: p[:amount],
      order_title: p[:order_title],
      notify_url: AppConfig.get('pooul','notify_url') + "/test_notify/#{order_num}",
      callback_url: AppConfig.get('pooul','callback_url') + "/test_callback/#{order_num}",
      remote_ip: p[:remote_ip] || request.remote_ip,
    }
    js_biz[:auth_code] = p[:auth_code] if p[:auth_code]
    js_request = {
      org_code: p[:org_code],
      method: p[:method],
      data: js_biz.to_json,
      redirect: p[:redirect]
    }
    org = Org.find_by(org_code: p[:org_code])
    if org
      js_request[:sign] = Biz::PooulApi.get_mac(js_biz, org.tmk)
      url = AppConfig.get('pooul', 'pay_url')
      if resp = Net::HTTP.post_form(URI(url), js_request)
        if resp.is_a?(Net::HTTPRedirection)
          redirect_to resp['location'], status: 302
          return
        end
        if resp.body
          begin
            @js = JSON.parse(resp.body).symbolize_keys
          rescue => e
            @js = {error: e.message}
          end
        else
          @js = {error: "[BIZ] #{resp.inspect}"}
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
