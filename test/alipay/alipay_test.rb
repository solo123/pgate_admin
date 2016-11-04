require 'test_helper'

class AlipayTest < ActionDispatch::IntegrationTest
  test "第三方授权" do
    url = 'https://openauth.alipay.com/oauth2/appToAppAuth.htm'
    js_sandbox = {
      app_id: '2016072900117068',
      redirect_uri: 'http://112.74.184.236:8008/callback/alipay_test'
    }
    js = {
      app_id: '2016101502183655',
      redirect_uri: 'http://112.74.184.236:8008/callback/alipay_test'
    }
    uri = URI(url)
    uri.query = URI.encode_www_form(js)
    puts uri


  end
end
