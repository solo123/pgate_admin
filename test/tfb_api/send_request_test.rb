require 'test_helper'

class SendRequestTest < ActionDispatch::IntegrationTest
  test "post to TFB invalid" do
    url = "http://apitest.tfb8.com/cgi-bin/v2.0/api_wx_pay_apply.cgi"
    js = {a: 1, b: 2}
    ret = Biz::WebBiz.get_tfb(url, js, nil)

    #puts "-------GET TFB-------"
    #puts ret
    #{"root"=>{"retcode"=>"205216", "retmsg"=>"商户号参数错误", "tid"=>"api_wx_pay_apply"}}

    assert ret
    assert ret['root']

    rt = ret['root']
    assert_equal "api_wx_pay_apply", rt['tid']

  end
  test "post to TFB valid" do
    url = "http://apitest.tfb8.com/cgi-bin/v2.0/api_wx_pay_apply.cgi"
    notify_url = 'http://112.74.184.236:8011/recv_notify'
    order_id = 'ORD-' + Time.now.to_i.to_s + '-001'
    user_id = '1800314099'
    tmk = '12345'

    js = {
      spid: user_id,
      notify_url: notify_url,
      pay_show_url: 'http://a.pooulcloud.cn',
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
