require 'test_helper'
require "openssl"

class ZxTest < ActionDispatch::IntegrationTest
  DEBUG_MODE = true

  def log(*params)
    return unless DEBUG_MODE
    Rails.logger.info params.join("\n")
  end
  def setup
    load "#{Rails.root}/db/seeds.rb"
  end

  test 'request xml' do
    biz = Biz::ZxIntfcApi.new
    biz.set_mercht(zx_merchts(:one))    
    js = biz.gen_request
    if biz.err_code != '00'
      puts "error: " + biz.err_desc
    end
    puts js.to_s
  end

end
