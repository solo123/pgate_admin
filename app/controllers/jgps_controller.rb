class JgpsController < ApplicationController
  def signin
    txt = %{
{
"sendTime":"#{Time.now.strftime("%Y%m%d%H%M%S")}",
"sendSeqId":"100010",
"transType":"A001",
"organizationId":"puerhanda"
}
    }
    params = { data: txt }
    url = 'http://61.135.202.242:8020/payform/organization'
    #url = 'http://127.0.0.1:3000/recv_posts'

    uri = URI(url)
    res = Net::HTTP.post_form(uri, data: txt)
    result_txt = res.body
    r_json = JSON.parse(result_txt)
    r = JgSignin.new(result_text: result_txt.force_encoding("UTF-8"), terminal_info: r_json["terminalInfo"].to_s)
    r.save
    render text: result_txt
  end
end
