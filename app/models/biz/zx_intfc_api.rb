module Biz
  class ZxIntfcApi < BizBase
    def set_mercht(zx_mercht)
      @zx_mercht = zx_mercht
    end

    def gen_request
      return nil unless @zx_mercht

      @err_code = '00'
      js = {}
      mab = ''
      missed_require_fields = []
      ZxField.api_fields('0100SDC0').each do |zx_field|
        fld = zx_field.field_name || zx_field.regn_en_nm.downcase
        if @zx_mercht[fld]
          js[zx_field.regn_en_nm] = @zx_mercht[fld]
          mab << @zx_mercht[fld] if zx_field.is_sign_regn
        elsif zx_field.regn_nt_null
          missed_require_fields << "#{zx_field.regn_en_nm}(#{zx_field.regn_cn_nm})"
        end
      end
      unless missed_require_fields.empty?
        @err_code = '03'
        @err_desc = "缺少必须的字段：" + missed_require_fields.join(", ")
      end
      js
    end
  end
end
