require 'test_helper'

class HzApiTest < ActionDispatch::IntegrationTest
  test "hz sign" do
    data = "abc123 abc\na 中文\n\r"

    fn = "#{AppConfig.get('pooul', 'keys_path')}/0029.pfx"
    k = OpenSSL::PKCS12.new(File.read(fn), 'password')

    sign = OpenSSL::PKCS7::sign(k.certificate, k.key, data, [],  OpenSSL::PKCS7::BINARY|OpenSSL::PKCS7::DETACHED)
    #sign.certificates = []
    #byebug
    pkcs7 = OpenSSL::PKCS7.new(sign.to_der)
    assert pkcs7.verify(pkcs7.certificates, OpenSSL::X509::Store.new, data, OpenSSL::PKCS7::NOVERIFY)
  end

end
