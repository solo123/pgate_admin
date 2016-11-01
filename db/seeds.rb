puts "Add AppConfig init data."
User.create(email: 'solo123@21cn.com', password: 'liang123', password_confirmation: 'liang123')
User.create(email: 'alei@pooul.com', password: 'alei123', password_confirmation: 'alei123')
AppConfig.set('pooul.api.pay_url', 'http://112.74.184.236:8008/pay')
AppConfig.set('pooul.api.query_url', 'http://112.74.184.236:8008/query')
