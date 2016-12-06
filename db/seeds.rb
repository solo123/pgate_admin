puts "Usage: rails db:seed refresh=yes"
prompt = '-----> '
puts "#{prompt}Add AppConfig init data."
puts "#{prompt}Add users"
User.create(email: 'solo123@21cn.com', password: 'liang123', password_confirmation: 'liang123')
User.create(email: 'alei@pooul.com', password: 'alei123', password_confirmation: 'alei123')

puts "#{prompt}Add base config"
AppConfig.set('pooul', 'pay_url', 'http://pay.pooulcloud.cn/pay')
AppConfig.set('pooul', 'query_url', 'http://pay.pooulcloud.cn/query')
AppConfig.set('pooul', 'notify_url', 'http://cb.pooulcloud.cn/notify')
AppConfig.set('pooul', 'callback_url', 'http://cb.pooulcloud.cn/callback')
AppConfig.set('alipay', 'notify.return', 'SUCCESS')
AppConfig.set('pfb', 'notify.return', 'SUCCESS')
AppConfig.set('zx', 'inftc_url', 'https://202.108.57.43:30280/')
