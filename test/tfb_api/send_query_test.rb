require 'test_helper'

class SendQueryTest < ActionDispatch::IntegrationTest
  test "query order" do
    return
    ret_js = {"cur_type"=>"CNY", "listid"=>"1021800314099161017000022022", "pay_info"=>"https%3A%2F%2Fpay.swiftpass.cn%2Fpay%2Fwappay%3Ftoken_id%3D350f52592759d6f7b804d2eea547e65c%26service%3Dpay.weixin.wappay", "pay_type"=>"800206", "retcode"=>"00", "retmsg"=>"操作成功", "sign"=>"f39821b0b438ec4acf374aab5a3efb0d", "sp_billno"=>"ORD-1476716315-001", "spid"=>"1800314099", "sysd_time"=>"20161017225837", "tran_amt"=>"1000"}
    url = "http://upay.tfb8.com/cgi-bin/v2.0/api_wx_pay_single_qry.cgi"
    tmk = '21ae47d4910b11e698eb6c0b84b7aa1a'
    #tmk = '12345'

    js = {
      spid: ret_js["spid"],
      sp_billno: ret_js["sp_billno"]
    }
    js = { spid: '1800329293', sp_billno: 'T1000028'}
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
    #end
    assert_equal "00", rt['retcode']
    #{"data"=>{"record"=>{"close_time"=>nil, "create_time"=>"2016-10-17 22:58:35", "item_attach"=>nil, "item_name"=>"Test-Good中文", "listid"=>"1021800314099161017000022022", "pay_time"=>nil, "pay_type"=>"800206", "sp_billno"=>"ORD-1476716315-001", "spid"=>"1800314099", "state"=>"2", "tran_amt"=>"1000"}}, "retcode"=>"00", "retmsg"=>"操作成功", "sign"=>"164ab7d00d0991edafbdfd72c0c22a2f", "sign_type"=>"MD5", "spid"=>"1800314099"}

  end
end
