class ZxClr < ApplicationRecord
  has_many :http_logs, as: :sender
end
