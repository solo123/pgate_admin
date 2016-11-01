require 'test_helper'

class PufubaoPayTest < ActionDispatch::IntegrationTest
  test "post to Pufubao invalid" do
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
=begin
    service_type
    mch_id
    customer_out_trade_ no
    device_inf o
    body
    attach
    total_fee
    "mch_creat
    e_ip "
    time_start
    op_user_i d
    op_shop_i d
    notify_url
    callback_url
    nonce_str
    sign
=end
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
    return
    url = "http://apitest.tfb8.com/cgi-bin/v2.0/api_wx_pay_apply.cgi"
    #url = "http://upay.tfb8.com/cgi-bin/v2.0/api_wx_pay_apply.cgi"
    notify_url = 'http://112.74.184.236:8010/notify/test_reqeust'
    callback_url = "http://112.74.184.236:8010/notify/test_reqeust_cb"
    order_id = 'ORD-' + Time.now.to_i.to_s + '-001'
    #user_id = '1800329293'
    #tmk = '21ae47d4910b11e698eb6c0b84b7aa1a'
    user_id = '1800314099'
    tmk = '12345'

    js = {
      spid: user_id,
      notify_url: notify_url,
      pay_show_url: callback_url,
      sp_billno: order_id,
      spbill_create_ip: '183.16.160.240',
      pay_type: '800206',
      tran_time: Time.now.strftime("%Y%m%d%H%M%S"),
      tran_amt: 1000,
      cur_type: 'CNY',
      item_name: 'Test-Good中文',
      bank_mch_name: 'APD001',
      bank_mch_id: '1200567'
    }
    mab = js.keys.sort.map{|k| "#{k}=#{js[k.to_sym]}"}.join('&')
    sign = Biz::PubEncrypt.md5(mab + "&key=#{tmk}").upcase

    js[:input_charset] = 'UTF-8'
    js[:sign] = sign
    ret = Biz::WebBiz.get_tfb(url, js, nil)
    assert ret
    assert ret['root']

    rt = ret['root']
    #if rt['retcode'] != '00'
      puts "-------GET TFB-------"
      puts "mab: " + mab
      puts "rt:  " + rt.to_s
      puts "pay: " + URI.decode(rt['pay_info'])
    #end
    assert_equal "00", rt['retcode']
    #{"cur_type"=>"CNY", "listid"=>"1021800314099161012000020661", "pay_info"=>"https%3A%2F%2Fpay.swiftpass.cn%2Fpay%2Fwappay%3Ftoken_id%3D91079346142fdcbfc0d0be8aae906f77%26service%3Dpay.weixin.wappay", "pay_type"=>"800206", "retcode"=>"00", "retmsg"=>"操作成功", "sign"=>"287696d6bf93f94edae1dfdcd93c50f4", "sp_billno"=>"ORD1476239835", "spid"=>"1800314099", "sysd_time"=>"20161012103718", "tran_amt"=>"100"}
  end
end
