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
AppConfig.set('zx', 'intfc_url', 'https://202.108.57.43:30280/')
AppConfig.set('hzyb', 'intfc_url', 'http://103.25.21.35:11111/gateway')

puts "#{prompt}Add SubMct!"
PfbMercht.all.each do |mct|
  if mct.org && mct.sub_mct.nil?
    sm = mct.org.sub_mcts.build
    sm.bank_mct = mct
    sm.save
    puts "#{prompt}Add sub_mct for: #{sm.bank_mct_type}"
  end
end
ZxMct.all.each do |mct|
  if mct.org && mct.sub_mct.nil?
    sm = mct.org.sub_mcts.build
    sm.bank_mct = mct
    sm.save
    puts "#{prompt}Add sub_mct for: #{sm.bank_mct_type}"
  end
end

if BusinessCatelog.where(channel_name: 'hzyb').count < 1
  puts "#{prompt}添加合众易宝经营类目"
  cat = %w(线下零售 1001 餐饮/食品 1002 票务/旅游 1003 教育/培训 1004 生活/咨询服务 1005 娱乐/健身服务 1006 医疗 1007 收藏/拍卖 1008 物流/快递 1009 公益 1010 通讯 1011 金融/保险 1012 网络虚拟服务 1013 生活缴费 1014 酒店 1015 家居 1016 电商团购 1017 其他 1018)
  cat.each_slice(2) do |ct|
    BusinessCatelog.create(channel_name: 'hzyb', business_name: ct[0], v1: ct[1])
    puts ct
  end
end
