require 'test_helper'
require "openssl"

class ZxIntfcTest < ActionDispatch::IntegrationTest
  DEBUG_MODE = true

  def log(*params)
    return unless DEBUG_MODE
    Rails.logger.info params.join("\n")
  end

  test "file md5" do
    f_md5 = Digest::MD5.hexdigest(File.read("#{Rails.root}/test/zx/zxzhmx.zip"))
    assert_equal 'ae351b342df716825cfc8d44b0bd9f46', f_md5
  end

  test "zx sign" do
    #certificate = 'MIIDITCCAgmgAwIBAgIBMDANBgkqhkiG9w0BAQUFADArMQswCQYDVQQGEwJDTjENMAsGA1UECwwEUFROUjENMAsGA1UEAwwEdGVzdDAeFw0xNjA5MDYxMDMzMzlaFw0yNjA5MDQxMDMzMzlaMCsxCzAJBgNVBAYTAkNOMQ0wCwYDVQQLDARQVE5SMQ0wCwYDVQQDDAR0ZXN0MIIBIjANBgkqhkiG9w0BAQEFAAOCAQ8AMIIBCgKCAQEAhJfufuUP92Gonrhxo1wBqO1nh3+yUlorF+UySal5+BWalQU6QY1K2rUprxRF6y9rO6J+qel83juWXkYdtyH0shJEDPLfmEe4iUIWzNPJHRPi4Uwsg1CNOnLI93mrbh0sXlOAhwMxqhBD5GdcEDyXYm9egttegXgbVFNG9frBVxu3tjkqlwxPVAHNR78Atuj/avaM705EiKWScm1Hxc5fmbJQCLSy1pMX5/V5z5m1yk3DjkFo98aqRdFzJaR+gqPk1mSv8rPn2BvT8nIrrMRmVOH2VzX/wDiKMpvuGQcq8l9deoTSMphR30XfYs6MQ/9OWDH49/xBEGnUV9bG3GoLbwIDAQABo1AwTjAdBgNVHQ4EFgQUWaZ57KamnQXLHbvsRS4sm5gM3vswHwYDVR0jBBgwFoAUWaZ57KamnQXLHbvsRS4sm5gM3vswDAYDVR0TBAUwAwEB/zANBgkqhkiG9w0BAQUFAAOCAQEABSgrIpZdXWGvgE7n/R81UlvtWTP7Zl9nqSLedEZu6b01YBPGdNsIccMaa8RVrkMkwE/kgrsEuHF8V1hf3VHCIkhaZ78A+8dKAiYFX6Z1bMH0epsgKUiwWTQygQPCrQApvflPN8mu0ieYiWVpcISMA+JziA3keQphGgBN8ocE4WBwgM/biCYFg1abF3LiXA9gh7wu+w3mpy5NTNuU4HONFdfDSHu8+HG87Yu0E+cz3iDK9gZkPXZhhjG61IZusR55gOyyJZkhvv+2f40C+X1Ryw+kJyk7w2iOhRPqTvHzGMiqI1wmDi4QoCS6traMnSnyERwK3NDhSRceTJSD9Pn+7g=='
    data        = 'abc123'

    key = OpenSSL::PKey::RSA.new(File.read("#{AppConfig.get('pooul', 'keys_path')}/zx_test_priv_key.pem"))
    crt = OpenSSL::X509::Certificate.new(File.read("#{AppConfig.get('pooul', 'keys_path')}/zx_test_public_key.pem"))

    sign = OpenSSL::PKCS7::sign(crt, key, data, [], OpenSSL::PKCS7::DETACHED)
    sign.certificates = []

    v_sn = Base64.strict_encode64 sign.to_der
    #puts "Sign:"
    #puts v_sn.inspect


    pkcs7 = OpenSSL::PKCS7.new(sign.to_der)
    assert pkcs7.verify([crt], OpenSSL::X509::Store.new, data, OpenSSL::PKCS7::NOVERIFY)
  end

  test "get_mab" do
    attach = stub(
      attach_asset_identifier: 'aid',
      attach_asset: stub(url: "/../test/fixtures/attach_1.data")
    )
    Org.any_instance.stubs(:attachments).returns(stub(find_by: attach))

    biz = Biz::ZxIntfcApi.new(orgs(:one))
    biz.prepare_request
    mab = /^10000007201610201155000290001商户入驻测试普尔支付12016062900190127测试中国银行金融街支行102100004943(.+)00010003201612200.00300010002201612200.00300010001201612200.00300100SDC1$/
    #puts biz.inspect
    assert_match mab, biz.mab.encode('utf-8', 'gbk')
  end

  test "test stub" do
    # attach = OpenStruct.new
    # attach.attach_asset_identifier = 'aid'
    # attach.attach_asset = OpenStruct.new(url: 'aurl')
    attach = stub(attach_asset_identifier: 'aid', attach_asset: stub(url: 'aurl'))
    Org.any_instance.stubs(:attachments).returns(stub(find_by: attach))

    org = orgs(:one)
    lics = org.attachments.find_by(tag_name: 'lics')
    assert_equal attach, lics
    assert_equal "aid", lics.attach_asset_identifier
    assert_equal "aurl", lics.attach_asset.url
  end
  test "gen zx_intfc request" do
    attach = stub(
      attach_asset_identifier: 'aid',
      attach_asset: stub(url: "/../test/fixtures/attach_1.data")
    )
    Org.any_instance.stubs(:attachments).returns(stub(find_by: attach))

    biz = Biz::ZxIntfcApi.new(orgs(:one))
    biz.prepare_request
    #puts biz.xml
    xml = Nokogiri::XML(biz.xml)
    assert xml.errors.empty?
    assert_equal 1, xml.xpath("//Contr_Info_List").count
    assert_equal 1, xml.xpath("//Comm_Fee_Acct_Typ").count
    assert_equal '00', biz.err_code
    #File.write('test/zx/zx_m1.xml', biz.xml)
  end
  test "send zx_intfc new client timeout" do
    attach = stub(
      attach_asset_identifier: 'aid',
      attach_asset: stub(url: "/../test/fixtures/attach_1.data")
    )
    Org.any_instance.stubs(:attachments).returns(stub(find_by: attach))
    stub_request(:any, "http://intfc.zx.com").to_return(status: 500, body: "ERROR")

    org = orgs(:one)
    biz = Biz::ZxIntfcApi.new(org)
    biz.prepare_request
    biz.send_zx_intfc
    assert_equal '20', biz.err_code
    assert_equal 0, org.zx_mct.status
  end
  test "send zx_intfc new client sign error" do
    attach = stub(
      attach_asset_identifier: 'aid',
      attach_asset: stub(url: "/../test/fixtures/attach_1.data")
    )
    Org.any_instance.stubs(:attachments).returns(stub(find_by: attach))
    server_rtn = '<?xml version="1.0" encoding="GBK"?> <ROOT> <Chnl_Id></Chnl_Id> <Chnl_Mercht_Id></Chnl_Mercht_Id> <Pay_Chnl_Encd></Pay_Chnl_Encd> <Rtrn_Doc></Rtrn_Doc> <Clr_Dtl></Clr_Dtl> <Clr_Dt></Clr_Dt> <syn_file></syn_file> <Dtl_Memo></Dtl_Memo> <rtncode>30000001</rtncode> <rtninfo>验签失败，请检查签名！</rtninfo> <Msg_Sign></Msg_Sign> </ROOT>'.encode('gbk', 'utf-8')
    stub_request(:any, "http://intfc.zx.com").to_return(status: 200, body: server_rtn)

    org = orgs(:one)
    biz = Biz::ZxIntfcApi.new(org)
    biz.prepare_request
    biz.send_zx_intfc
    assert_equal '20', biz.err_code
    assert_equal 0, org.zx_mct.status
  end

  test "send zx_intfc new client success" do
    attach = stub(
      attach_asset_identifier: 'aid',
      attach_asset: stub(url: "/../test/fixtures/attach_1.data")
    )
    Org.any_instance.stubs(:attachments).returns(stub(find_by: attach))
    server_rtn = '<?xml version="1.0" encoding="GBK"?> <ROOT> <Chnl_Id>10000007</Chnl_Id> <Chnl_Mercht_Id>pooul</Chnl_Mercht_Id> <Pay_Chnl_Encd>0001</Pay_Chnl_Encd> <Rtrn_Doc></Rtrn_Doc> <Clr_Dtl></Clr_Dtl> <Clr_Dt></Clr_Dt> <syn_file></syn_file> <Dtl_Memo></Dtl_Memo> <rtncode>00000000</rtncode> <rtninfo>商户信息维护申请成功</rtninfo> <Msg_Sign>MIAGCSqGSIb3DQEHAqCAMIACAQExCzAJBgUrDgMCGgUAMIAGCSqGSIb3DQEHAQAAMYIBtjCCAbICAQEwMDArMQswCQYDVQQGEwJDTjENMAsGA1UECwwEUFROUjENMAsGA1UEAwwEdGVzdAIBMDAJBgUrDgMCGgUAoF0wGAYJKoZIhvcNAQkDMQsGCSqGSIb3DQEHATAcBgkqhkiG9w0BCQUxDxcNMTYxMjExMDIwMjQwWjAjBgkqhkiG9w0BCQQxFgQUjYrApzcFaeVawn3+mLsmB1dgM1AwDQYJKoZIhvcNAQEBBQAEggEAPb0aXQIy35UZ20qzhhuvpjNiWpB0dS2ghrVmVeWv3xhlGb0WM8DQWTLtPq4LkauctUxjIHBzRVetZ2ZukWj9Fs4WRyaINXnaJq8xjKBIFT31W8VDyFJzggG0L+8rfdMI67tQlQHYMH+ZSO/izqFgyfDyELmA8qwgFRNd04cLDy5gw84hXtjAZomQbgDp5s9Vr4wnBXk8E9ROg3NrDsZK3RxOFfp6fmSKYs1XL/q3dOuDLKpiZPxvam5R8wwFsk9Rgn7uNjy9l2lp6U1V7CSYzk8ANpKfOTLyKPX0/+XnU7X0+bh9YEnnhsBH1R9c1RgCS6UwdBsaiESPeQ2uZjdjqwAAAAAAAA==</Msg_Sign> </ROOT>'.encode('gbk', 'utf-8')
    stub_request(:any, "http://intfc.zx.com").to_return(status: 200, body: server_rtn)

    org = orgs(:one)
    biz = Biz::ZxIntfcApi.new(org)
    biz.prepare_request
    biz.send_zx_intfc
    assert_equal '00', biz.err_code
    assert_equal 1, org.zx_mct.status
  end

end
