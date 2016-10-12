require 'test_helper'

class TfbMacTest < ActionDispatch::IntegrationTest
  test "tfb mac" do
    s = "spid=1888888888&total_money=1&key=8db4a013a8b515349c307f1e448ce836"
    mac = Biz::PubEncrypt.md5(s).upcase
    assert_equal "9B4D6E67145AB87591A7F4F4679C8566", mac
  end
  test "tfb mac with space" do
    s = "item_name=abc def&spid=1888888888&total_money=1&key=12345"
    mac = Biz::PubEncrypt.md5(s).upcase
    assert_equal "2FBD5AC12C237DD454031512652E387B", mac
  end

end
