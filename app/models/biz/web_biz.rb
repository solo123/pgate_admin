module Biz
  class WebBiz < BizBase
    def self.get_tfb(url, data, sender)
      pd = PostDat.new
      pd.sender = sender
      pd.url = url
      pd.data = data.to_s

      ret = nil
      begin
        uri = URI(url)
        #uri.query = URI.encode(data)
        uri.query = URI.encode_www_form(data)
        #puts "uri: " + uri.to_s
        resp = Net::HTTP.get_response(uri)
        pd.response = resp.inspect
        if resp.is_a?(Net::HTTPOK)
          body_txt = resp.body
          ret = Hash.from_xml(body_txt)
          pd.body = ret.to_s
        else
          err = BizError.new
          err.code = '96'
          err.message = "系统故障"
          err.detail = "not HTTPOK!\n" + resp.to_s + "\n" + resp.to_hash.to_s
          err.error_source = sender
          err.save!
        end
      rescue => e
        err = BizError.new
        err.code = '96'
        err.message = "系统故障"
        err.detail = "request error!\n#{e.message}\n#{body_txt}"
        err.error_source = sender
        err.save!
        pd.error_message = e.message
      end
      pd.save!
      ret
    end

  end
end
