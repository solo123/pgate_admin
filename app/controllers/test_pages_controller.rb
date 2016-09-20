class TestPagesController < PubController
  def do_post
    params.permit!
    p = params[:payment]
    js = {
      org_id: p[:org_id],
      trans_type: 'P001',
      order_time: Time.now.strftime("%Y%m%d%H%M%S"),
      order_id: "ADM" + Time.now.to_i.to_s,
      pay_pass: "1",
      amount: p[:amount],
      fee: p[:fee],
      card_no: '6225886556455713',
      card_holder_name: '梁益华',
      person_id_num: '450303197005030016',
      order_title: p[:order_title],
      notify_url: 'http://112.74.184.236:8080/recv_notify',
      callback_url: "http://a.pooulcloud.cn/test_pages"
    }
    client = Client.find_by(org_id: p[:org_id])
    if client
      biz = Biz::PubEncrypt.new
      js[:mac] = biz.md5_mac(js, client.tmk)
      uri = URI('http://112.74.184.236:8008/payment')
      resp = Net::HTTP.post_form(uri, data: js.to_json)
      if resp.is_a? Net::HTTPOK
        begin
          j = JSON.parse(resp.body)
          redirect_to j['redirect_url']
        rescue => e
          render plain: "redirect error: #{e.message}\nresp = " + resp.to_s + "\nresp.body = " + resp.body.to_s
        end
      else
        render plain: "resp = #{resp.to_s}\nresp.body=#{resp.body}"
      end
    else
      render plain: "org:[#{p[:org_id]}] not found!\n"
      return
    end
  end

end
