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
        zio.write File.read("#{Rails.root}/public#{URI.decode(lics.attach_asset.url)}")
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
            val = r['f_name'] ? eval(r['f_name']) : org.zx_mct[r['regn_en_nm'].downcase]
            unless val == "NO_VALUE"
              xml.send r['regn_en_nm'], val
              if val
                mabs << val if r['is_sign_regn'] == "1"
              else
                missed_require_fields << "#{r['regn_en_nm']}(#{r['regn_cn_nm']})" if r['regn_nt_null'] == "1"
              end
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
    def contr_info_list(xml, mabs)
      xml.Contr_Info_List {
        @org.zx_mct.zx_contr_info_lists.each do |cl|
          xml.Contrinfo {
            xml.Pay_Typ_Encd cl.pay_typ_encd
            xml.Pay_Typ_Fee_Rate cl.pay_typ_fee_rate
            xml.Start_Dt cl.start_dt
          }
          mabs << cl.pay_typ_encd
          mabs << cl.start_dt
          mabs << cl.pay_typ_fee_rate
        end
      }
      "NO_VALUE"
    end

    def sign(mabs)
      @mab = mabs.join().encode('GBK', 'UTF-8')
      key = OpenSSL::PKey::RSA.new(File.read("#{AppConfig.get('pooul', 'keys_path')}/zx_prod_key.pem"))
      crt = OpenSSL::X509::Certificate.new(File.read("#{AppConfig.get('pooul', 'keys_path')}/zx_prod.crt"))
      sign = OpenSSL::PKCS7::sign(crt, key, @mab, [], OpenSSL::PKCS7::DETACHED)
      sign.certificates = []
      Base64.strict_encode64 sign.to_der
    end

    def send_zx_intfc
      if @xml
        url = AppConfig.get('zx', 'intfc_url')
        pd = post_xml_gbk('zx_intfc', url, @xml, @org.zx_mct)
        @post_data = pd
        @err_desc = nil
        if pd.resp_body
          xml = Nokogiri::XML(pd.resp_body.encode('gbk', 'utf-8'))
          if xml.xpath("//rtncode").text == '00000000'
            @org.zx_mct.status = 1
            @org.zx_mct.save!
          else
            @err_code = '20'
            @err_desc = xml.xpath("//rtninfo").text
          end
        else
          @err_code = '20'
          @err_desc = 'null返回值'
        end
      else
        @err_code = '20'
        @err_desc = '数据不齐，提交失败！' + biz.err_desc.to_s
      end
    end

    def send_zx_query
      mab_query = []
      mab_query << @org.zx_mct.chnl_id
      mab_query << @org.zx_mct.chnl_mercht_id
      mab_query << @org.zx_mct.pay_chnl_encd
      mab_query << '0100SDC0'
      builder = Nokogiri::XML::Builder.new(:encoding => 'GBK') do |xml|
        xml.ROOT {
          xml.Chnl_Id @org.zx_mct.chnl_id
          xml.Chnl_Mercht_Id @org.zx_mct.chnl_mercht_id
          xml.Pay_Chnl_Encd @org.zx_mct.pay_chnl_encd
          xml.trancode '0100SDC0'
          xml.Msg_Sign sign(mab_query)
        }
      end
      pd = post_xml_gbk('zx_intfc_query', AppConfig.get('zx', 'intfc_url'), builder.to_xml, @org.zx_mct)
      @post_data = pd
      @err_code = '00'
      @err_desc = nil
      if pd.resp_body
        xml = Nokogiri::XML(pd.resp_body.encode('gbk', 'utf-8'))
        if xml.xpath("//rtncode").text == '00000000'
          @org.zx_mct.status = 1
          @org.zx_mct.save!
        else
          @err_code = '20'
          @err_desc = xml.xpath("//rtninfo").text
        end
      else
        @err_code = '20'
        @err_desc = '请求返回为空'
      end
    end
    def send_zx_clr(clr_dt)
      channel = Channel.find_by(channel_code: 'zx_alipay')
      clr = ZxClr.find_or_create_by(clr_dt: clr_dt)
      clr.chnl_id = channel.channel_out_code
      clr.pay_chnl_encd = channel.biz_out_code
      clr.clr_dt = clr_dt
      clr.trancode = '0100SDC4'
      clr.save!

      mab_query = []
      mab_query << clr.chnl_id
      mab_query << clr.pay_chnl_encd
      mab_query << clr.clr_dt
      mab_query << clr.trancode
      builder = Nokogiri::XML::Builder.new(:encoding => 'GBK') do |xml|
        xml.ROOT {
          xml.Chnl_Id clr.chnl_id
          xml.Pay_Chnl_Encd clr.pay_chnl_encd
          xml.Clr_Dt clr.clr_dt
          xml.trancode clr.trancode
          xml.Msg_Sign sign(mab_query)
        }
      end
      pd = post_xml_gbk('zx_clr', channel.prepay_url, builder.to_xml, clr)
      @post_data = pd
      @err_code = '00'
      @err_desc = nil
      if pd.resp_body
        xml = Nokogiri::XML(pd.resp_body.encode('gbk', 'utf-8'))
        if xml.xpath("//rtncode").text == '00000000'
          clr.rtncode = xml.xpath("//rtncode").text
          clr.rtninfo = xml.xpath("//rtninfo").text
          clr.dtl_memo = xml.xpath("//Dtl_Memo").text
          clr.status = 1
          clr.save!
        else
          @err_code = '20'
          @err_desc = xml.xpath("//rtninfo").text
        end
      else
        @err_code = '20'
        @err_desc = '请求返回为空'
      end
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
