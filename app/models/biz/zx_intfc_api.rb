require 'zip'
module Biz
  class ZxIntfcApi < BizBase
    attr_accessor :mab, :xml

    def initialize(org)
      @org = org
    end

    def prepare_request
      @mab = @xml = nil
      return nil unless @org && @org.zx_mct && @org.merchant

      @err_code = '00'
      mabs = []
      missed_require_fields = []

      lics = @org.attachments.find_by(tag_name: 'lics')
      return nil unless lics
      stringio = Zip::OutputStream.write_buffer do |zio|
        zio.put_next_entry(lics.attach_asset_identifier)
        zio.write File.read("#{Rails.root}/public#{lics.attach_asset.url}")
      end
      lics_file = stringio.string
      lics_md5 = Digest::MD5.hexdigest(lics_file)
      lics_file = Base64.encode64(lics_file)
      org = @org
      trancode = '0100SDC1'
      appl_typ = 0 #新增：0；变更：1；停用：2
      builder = Nokogiri::XML::Builder.new(:encoding => 'GBK') do |xml|
        xml.ROOT {
          CSV.foreach("#{Rails.root}/config/zx_reg_fields.csv", headers: true) do |r|
            if r['f_name']
              val = eval(r['f_name'])
            else
              val = org.zx_mct[r['regn_en_nm'].downcase]
            end
            xml.send r['regn_en_nm'], val
            mabs << val if r['is_sign_regn'] == 1
            missed_require_fields << "#{r['regn_en_nm']}(r['regn_cn_nm'])"
          end
        }
      end
      @xml = builder.to_xml
      @err_code = '00'
      unless missed_require_fields.empty?
        @err_code = '03'
        @err_desc = "缺少必须的字段：\n" + missed_require_fields.join("\n")
      end
    end

    def gen_contr_list(xml, mabs)
      xml.Contr_Info_List {
        @org.zx_mct.zx_contr_info_lists.each do |cl|
          xml.Contrinfo {
            xml.Pay_Typ_Encd cl.pay_typ_encd
            xml.Start_Dt cl.start_dt
            xml.Pay_Typ_Fee_Rate cl.pay_typ_fee_rate
          }
          mabs << cl.pay_typ_encd
          mabs << cl.start_dt
          mabs << cl.pay_typ_fee_rate
        end
      }
    end

    def sign(mabs)
      @mab = mabs.join().encode('GBK', 'UTF-8')
      key = OpenSSL::PKey::RSA.new(File.read("#{AppConfig.get('pooul', 'keys_path')}/zx_test_priv_key.pem"))
      crt = OpenSSL::X509::Certificate.new(File.read("#{AppConfig.get('pooul', 'keys_path')}/zx_test_public_key.pem"))
      sign = OpenSSL::PKCS7::sign(crt, key, @mab, [], OpenSSL::PKCS7::DETACHED)
      sign.certificates = []
      Base64.strict_encode64 sign.to_der
    end
  end
end
