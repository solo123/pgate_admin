class ZxField < ApplicationRecord
  scope :api_fields, -> (trancode) {
    where(trancode: trancode, msg_typ: 1, actv_stat: 1)
    .order(:sort_num)
  }

end
