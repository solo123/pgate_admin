require 'test_helper'

class KaiFuApiTest < ActionDispatch::IntegrationTest
  test "wechat openID D0 B001" do
    l = Rails.logger
    #l.level = :debug

    biz = Biz::KaiFuApi.new
    client_data = kaifu_gateways(:jimmy_liang)
    pooul_data = biz.fill_info_openid_d0(client_data)
    assert_equal 'B001', pooul_data.trans_type
    assert_equal Biz::KaiFuApi::ORG_ID, pooul_data.organization_id
    assert_equal Biz::KaiFuApi::NOTIFY_URL, pooul_data.notify_url
    assert_equal Biz::KaiFuApi::CALLBACK_URL, pooul_data.callback_url
    assert_equal 0, pooul_data.status

    pooul_data.send_time = Time.now.strftime("%Y%m%d%H%M%S")
    pooul_data.send_seq_id = "TST01" + Time.now.to_i.to_s

    mab, para_json, mac = biz.get_mac(pooul_data)
    assert_match /^\{/, para_json
    l.info 'MAB: ' + mab
    l.info 'JSON: ' + para_json
    l.info 'MAC: ' + mac

    uri = URI(Biz::KaiFuApi::API_URL_OPENID)
    resp = Net::HTTP.post_form(uri, data: para_json)
    Rails.logger.info '------KaiFu D0 B001------'
    Rails.logger.info resp.to_s
    Rails.logger.info resp.to_hash
    assert resp.is_a?(Net::HTTPRedirection)
    assert_match /^https:\/\/open.weixin.qq.com/, resp['location']
  end
end
