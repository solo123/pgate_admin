class HomeController < ApplicationController
  respond_to :html, :js
  def index
  end
  def kaifu_signin
    js =
{
sendTime: "#{Time.now.strftime("%Y%m%d%H%M%S")}",
sendSeqId: "SIGNIN#{Time.now.to_i.to_s}",
transType: "A001",
organizationId: "puerhanda"
}

    url = 'http://61.135.202.242:8020/payform/organization'
    uri = URI(url)
    res = Net::HTTP.post_form(uri, data: js.to_json)
    if res.is_a?(Net::HTTPOK)
      @result = res.body.to_s
      begin
        r_js = JSON.parse(@result)
        r = KaifuSignin.new(js_to_app_format(js))
        r.update(js_to_app_format(r_js))
        r.save
        @result = "[签到成功]\n\n#{@result.force_encoding('UTF-8')}"
      rescue => e
        @result = "[签到失败] #{e.message}\n\n" + @result.force_encoding('UTF-8')
      end
    end
  end

  def js_to_app_format(js)
    r = {}
    js.keys.each {|k| r[k.to_s.underscore] = js[k].to_s}
    r
  end


end
