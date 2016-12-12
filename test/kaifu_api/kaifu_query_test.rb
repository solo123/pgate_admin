require 'test_helper'
#require 'net/http'

class KaifuQueryTest < ActionDispatch::IntegrationTest
  test "query to kaifu" do
    return
    query_url	= "http://61.135.202.242:8022/payform/organization"
    tmk = "9DB9095654D1FA7763F32E6B4E922140"

    js = {
      sendTime: Time.now.strftime("%Y%m%d%H%M%S"),
      sendSeqId: 'Q' + Time.now.to_i.to_s,
      transType: 'B003',
      organizationId: 'puerhanda',
      orgSendSeqId: 'P1000003',
      transTime: '20160920'
    }
    mab = Biz::PubEncrypt.get_mab(js)
    js[:mac] = Biz::PubEncrypt.md5(mab + tmk)

    uri = URI(query_url)
    resp = Net::HTTP.post_form(uri, data: js.to_json)
    puts "------query-------"
    puts "Resp: " + resp.to_s
    puts "body: " + resp.body.to_s
=begin
Resp: #<Net::HTTPOK:0x007f91fec63af8>
body: {"organizationId":"puerhanda","sendTime":"20160924011507",
"t0RespDesc":"承兑或交易成功","payResult":"00","transType":"B003",
"sendSeqId":"Q1474650907","t0RespCode":"00","transTime":"20160920",
"payDesc":"支付成功","orgSendSeqId":"P1000003",
"respCode":"00","respDesc":"交易成功"}
=end
  end
end
