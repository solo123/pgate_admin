require 'test_helper'

class MacTest < ActionDispatch::IntegrationTest
  test "tfb mac" do
    s = "input_charset=GBK&spid=1888888888&total_money=1&key=8db4a013a8b515349c307f1e448ce836"
    mac = Biz::PubEncrypt.md5(s).upcase
    assert_equal "707950F66A57B3F59963023173B55B72", mac
  end
end
