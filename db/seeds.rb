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

require 'csv'
if ENV["refresh"]
  puts "#{prompt}REFRESH: zx_fields"
  ZxField.delete_all
end
if ZxField.count < 1
  puts "#{prompt}Add zx intfc_comnt.csv"
  %w(zx_intfc_comnt zx_intfc_list_regn_comnt).each do |csv_file|
    CSV.foreach("#{Rails.root}/db/#{csv_file}.csv") do |row|
      ZxField.create(
        trancode: row[0].strip, msg_typ: row[1], regn_en_nm: row[2].strip,
        regn_cn_nm: row[3].strip, sort_num: row[4], regn_data_typ: row[5].strip,
        regn_nt_null: row[6], is_sign_regn: row[7], actv_stat: row[8],
        table_name: nil, field_name: nil
      )
    end
  end
  if zx = ZxField.find_by(regn_en_nm: 'Mercht_Full_Nm')
    zx.field_name = 'mercht_full_name'
    zx.save
  end
end
