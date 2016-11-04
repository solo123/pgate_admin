require 'test_helper'

class PufubaoPayTest < ActionDispatch::IntegrationTest
  test "post to Pufubao invalid" do
    return
    url = "http://pay.pufubao.net/weixin/toPay"
    xml = %{<xml>
  <attach>测试附加数据</attach>
  <body>测试商品名称</body>
  <customer_out_trade_no>201606201434222581020672999</customer_out_trade_no>
  <device_info>SN123456</device_info>
  <mch_create_ip>1.1.1.1</mch_create_ip>
  <mch_id>6544238355</mch_id>
  <nonce_str>71e1d98819494ebdbd4d0e8776b9ba72</nonce_str>
  <notify_url>http://www.baidu.com</notify_url>
  <op_user_id>001</op_user_id>
  <service_type>SCANNED</service_type>
  <sign>88f240204975d3060202c724b6b479ae</sign>
  <time_expire>20160620143922</time_expire>
  <time_start>20160620143422</time_start>
  <total_fee>1</total_fee>
</xml>}
    begin
      uri = URI(url)
      request = Net::HTTP::Post.new(uri)
      request.body = xml
      request.content_type = 'text/xml'
      response = Net::HTTP.new(uri.host, uri.port).start { |http| http.request request }
      puts "-------GET TFB-------"
      puts response.inspect
      puts response.body
    rescue => e
      puts "ERROR: " + e.message
    end

  end

  test "post to Pufubao valid" do

    url = "http://brcb.pufubao.net/gateway"
    notify_url = 'http://112.74.184.236:8010/notify/test_reqeust'
    callback_url = "http://112.74.184.236:8010/notify/test_reqeust_cb"
    order_id = 'ORD-' + Time.now.to_i.to_s + '-001'
    mch_id = "C147815927610610144"
    key = "80ec3fa34fa04d8fa369d6170aaa55a2"
    js = {
      service_type: 'WECHAT_WEBPAY',
      mch_id: mch_id,
      nonce_str: 'abcd',
      body: 'test1',
      out_trade_no: order_id,
      total_fee: '1000',
      spbill_create_ip: '127.0.0.1',
      notify_url: 'http://112.74.184.236:8008/notify/pufubao_test',
      trade_type: 'JSAPI'
    }

    mab = js.keys.sort.map{|k| "#{k}=#{js[k.to_sym]}"}.join('&')
    sign = Biz::PubEncrypt.md5(mab + key).upcase
    #js[:input_charset] = 'UTF-8'
    js[:sign] = sign

    #debugger
    pd = Biz::WebBiz.post_data('test.pay', url, js, nil)

    puts "-------GET Pufubao-------"
    puts "---->JSON: " + js.to_json
    puts "---->MAB:  " + mab
    puts "---->post: " + pd.inspect
    puts "---->resu: " + pd.result_message.to_s
    puts "---->body: " + pd.resp_body.to_s
    assert pd
  end
end
