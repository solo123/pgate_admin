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
            val = nil
            if r['f_name']
              if r['f_name'] == 'list'
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
              else
                val = eval(r['f_name'])
              end
            else
              val = org.zx_mct[r['regn_en_nm'].downcase]
            end
            if val
              xml.send r['regn_en_nm'], val
              if r['is_sign_regn'] == "1"
                mabs << val
              end
            else
              missed_require_fields << "#{r['regn_en_nm']}(#{r['regn_cn_nm']})" if r['regn_nt_null'] == "1" && r['f_name'] != 'list'
            end
          end
          xml.Msg_Sign sign(mabs)
        }
      end
      @xml = builder.to_xml
      @err_code = '00'
      unless missed_require_fields.empty?
        @err_code = '03'
        @err_desc = "缺少必须的字段：\n" + missed_require_fields.join("\n")
      end
    end

    def sign(mabs)
      @mab = mabs.join().encode('GBK', 'UTF-8')
      key = OpenSSL::PKey::RSA.new(File.read("#{AppConfig.get('pooul', 'keys_path')}/zx_test_priv_key.pem"))
      crt = OpenSSL::X509::Certificate.new(File.read("#{AppConfig.get('pooul', 'keys_path')}/zx_test_public_key.pem"))
      sign = OpenSSL::PKCS7::sign(crt, key, @mab, [], OpenSSL::PKCS7::DETACHED)
      sign.certificates = []
      Base64.strict_encode64 sign.to_der
    end

    def post_xml_gbk(method, url, data, sender)
      pd = SentPost.new
      pd.method = method
      pd.sender = sender
      pd.post_url = url
      pd.post_data = 'xml data'

      begin
        uri = URI(url)
        https = Net::HTTP.new(uri.host, uri.port)
        https.use_ssl = (uri.scheme == "https")
        https.verify_mode = OpenSSL::SSL::VERIFY_NONE

        req = Net::HTTP::Post.new(uri, initheader = {"Content-Type": "text/xml"})
        req.body = data

        resp = nil
        https.start do |http|
          resp = http.request(req)
        end
        pd.resp_type = resp.inspect
        if resp.is_a?(Net::HTTPOK)
          pd.resp_body = resp.body.encode('utf-8', 'gbk')
        else
          pd.result_message = "not HTTPOK!\n" + resp.to_s + "\n" + resp.to_hash.to_s
        end
      rescue => e
        pd.result_message = "request error!\n#{e.message}"
      end
      pd.save!
      pd
    end

  end
end
