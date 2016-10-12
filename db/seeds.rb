puts "Add AppConfig init data."
AppConfig.set('kaifu.user.d0.org_id', 'puerhanda')
AppConfig.set('kaifu.user.d0.tmk', '9DB9095654D1FA7763F32E6B4E922140')
AppConfig.set('kaifu.user.t1.org_id', 'puerhandat101')
AppConfig.set('kaifu.user.t1.tmk', '0D45C00CC790614EF96A7AFE45B56C89')
AppConfig.set('kaifu.api.openid.pay_url', 'http://61.135.202.242/payform/organization_ymf')
AppConfig.set('kaifu.api.openid.query_url', 'http://61.135.202.242:8022/payform/organization')
AppConfig.set('kaifu.api.app.pay_url', 'http://61.135.202.242:8020/payform/organization')
AppConfig.set('kaifu.api.app.query_url', 'http://61.135.202.242:8022/payform/organization')
AppConfig.set('pooul.api.pay_url', 'http://112.74.184.236:8008/payment')
AppConfig.set('pooul.api.query_url', 'http://112.74.184.236:8009/query')
AppConfig.set('kaifu.user.d0.skey', '1234567890abcdef')
AppConfig.set('kaifu.user.t1.skey', '1234567890abcdef')
AppConfig.set('kaifu.host.notify', '61.135.202.242')
AppConfig.set('kaifu.api.notify_url', 'http://112.74.184.236:8010/notify/kaifu')
AppConfig.set('tfb.api.notify_url', 'http://112.74.184.236:8010/notify/tfb')
AppConfig.set('tfb.api.spid', '1800314099')
AppConfig.set('tfb.api.key', '12345')
AppConfig.set('tfb.api.pay_url', 'http://apitest.tfb8.com/cgi-bin/v2.0/api_wx_pay_apply.cgi')

puts "Add uni_order_id to ClientPayment."
ClientPayment.where(uni_order_id: nil).each do |c|
  c.order_time = c.created_at.strftime("%Y%m%d%H%M%S")
  c.uni_order_id = "#{c.org_id}-#{c.order_time[0..7]}-#{c.order_id}"
  c.save
end
