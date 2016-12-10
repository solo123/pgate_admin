require 'test_helper'
require "openssl"

class ZxTest < ActionDispatch::IntegrationTest
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
    return
    biz = Biz::ZxIntfcApi.new
    biz.set_mercht(zx_merchts(:one))
    mab = "1000000720161020115500029110000007商户入驻测试商户入驻测试15712945988张xx0755-8211000013900000000001zhang@company.com2016062900190127测试商户河南郑州郑州市金水区花园南路测试中国银行金融街支行1110210000494302000494192000514540md5_ABCD00100sdc1"
    assert_equal mab, biz.mab
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
    assert_equal '00', biz.err_code

    File.write('test/zx/zx_m1.xml', biz.xml)

  end

end
