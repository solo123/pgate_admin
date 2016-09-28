if AppConfig.count < 10
  puts "Add AppConfig init data."
  AppConfig.create(group: 'kaifu.user.d0.org_id', val: 'puerhanda')
  AppConfig.create(group: 'kaifu.user.d0.tmk', val: '9DB9095654D1FA7763F32E6B4E922140')
  AppConfig.create(group: 'kaifu.user.t1.org_id', val: 'puerhandat101')
  AppConfig.create(group: 'kaifu.user.t1.tmk', val: '0D45C00CC790614EF96A7AFE45B56C89')
  AppConfig.create(group: 'kaifu.api.openid.pay_url', val: 'http://61.135.202.242/payform/organization_ymf')
  AppConfig.create(group: 'kaifu.api.openid.query_url', val: 'http://61.135.202.242:8022/payform/organization')
  AppConfig.create(group: 'kaifu.api.app.pay_url', val: 'http://61.135.202.242:8020/payform/organization')
  AppConfig.create(group: 'kaifu.api.app.query_url', val: 'http://61.135.202.242:8022/payform/organization')
  AppConfig.create(group: 'pooul.api.notify_url', val: 'http://112.74.184.236:8010/recv_notify')
  AppConfig.create(group: 'pooul.api.pay_url', val: 'http://112.74.184.236:8008/payment')
  AppConfig.create(group: 'pooul.api.query_url', val: 'http://112.74.184.236:8009/query')
  AppConfig.create(group: 'kaifu.user.d0.skey', val: '1234567890abcdef')
  AppConfig.create(group: 'kaifu.user.t1.skey', val: '1234567890abcdef')
end
