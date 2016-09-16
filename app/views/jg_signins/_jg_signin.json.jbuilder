json.extract! jg_signin, :id, :result_text, :terminal_info, :created_at, :updated_at
json.url jg_signin_url(jg_signin, format: :json)