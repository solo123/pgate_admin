class TestPagesController < PubController
  def do_post
    params.permit!
    p = params[:payment]
    js = {
      org_id: p[:org_id],
      trans_type: p[:trans_type],
      order_time: Time.now.strftime("%Y%m%d%H%M%S"),
      order_id: "TST" + Time.now.to_i.to_s,
      pay_pass: "1",
      amount: p[:amount],
      fee: p[:fee],
      order_title: p[:order_title],
      notify_url: 'http://112.74.184.236:8080/recv_notify',
      callback_url: "http://a.pooulcloud.cn/test_pages/pay"
    }
    if p[:trans_type] == 'P001' || p[:trans_type] == 'P003'
      js[:card_no] = '6225886556455713'
      js[:card_holder_name] = '梁益华'
      js[:person_id_num] = '450303197005030016'
    end

    client = Client.find_by(org_id: p[:org_id])
    if client
      biz = Biz::PubEncrypt.new
      js[:mac] = biz.md5_mac(js, client.tmk)
      #uri = URI('http://112.74.184.236:8008/payment')
      uri = URI('http://localhost:8008/payment')
      resp = Net::HTTP.post_form(uri, data: js.to_json)
      if resp.is_a? Net::HTTPOK
        begin
          body_txt = resp.body.force_encoding('UTF-8')
          @js = JSON.parse(body_txt)
          @js.symbolize_keys!
        rescue => e
          @js = {error: e.message, resp: resp.to_s, body: body_txt}
        end
      else
        @js = {resp: resp.to_s, body: resp.body.to_s}
      end
    else
      @js = {error: "org:[#{p[:org_id]}] not found!\n"}
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
  end
end
