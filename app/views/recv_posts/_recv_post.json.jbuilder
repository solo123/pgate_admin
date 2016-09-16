json.extract! recv_post, :id, :remote_host, :header, :body, :created_at, :updated_at
json.url recv_post_url(recv_post, format: :json)