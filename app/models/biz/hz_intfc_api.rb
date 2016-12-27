module Biz
  class HzIntfcApi < BizBase
    attr_accessor :sub_mct, :xml

    def initialize(sub_mct)
      @err_code = '00'
      @sub_mct = sub_mct
      @req_type = nil
    end

    def modify_request_xml
      builder = Nokogiri::XML::Builder.new(:encoding => 'GBK') do |xml|
        xml.AIPG {
          xml.INFO {
            xml.TRX_CODE '100013'
            xml.VERSION '01'
            xml.REQ_SN 'merchantInModify-' + Time.now.to_i.to_s + '-100012'
            xml.SIGNED_MSG '[sign]'
          }
          xml.BODY {
            xml.TRANS_DETAIL {
              xml.MERCHANT_ID @sub_mct.parent_mch_id # 合众主商户代码(必填)
              xml.SUBMERCHANT_CODE @sub_mct.mch_id
              xml.IN_CHANNEL '1'
              xml.SUBMERCHANT_SHORTNAME @sub_mct.org.name
              xml.SUBMERCHANT_ADDRESS @sub_mct.org.merchant.address
              xml.SUBMERCHANT_SERVICEPHONE @sub_mct.org.merchant.service_tel
            }
          }
        }
      end
      @req_type = :modify
      @xml = builder.to_xml
    end
    def intfc_request_xml
      builder = Nokogiri::XML::Builder.new(:encoding => 'GBK') do |xml|
        xml.AIPG {
          xml.INFO {
            xml.TRX_CODE '100012'
            xml.VERSION '01'
            xml.REQ_SN 'ORD-' + Time.now.to_i.to_s + '-001'
            xml.SIGNED_MSG '[sign]'
          }
          xml.BODY {
            xml.TRANS_DETAIL {
              xml.IN_CHANNEL '1'
              xml.QRCODE_CHANNEL @sub_mct.pay_channel_type
              xml.MERCHANT_ID @sub_mct.parent_mch_id # 合众主商户代码(必填)
              xml.SUBMERCHANT_CODE @sub_mct.mch_id
              xml.SUBMERCHANT_NAME @sub_mct.org.merchant.full_name
              xml.SUBMERCHANT_SHORTNAME @sub_mct.org.name
              xml.SUBMERCHANT_ADDRESS @sub_mct.org.merchant.address
              xml.SUBMERCHANT_SERVICEPHONE @sub_mct.org.merchant.service_tel
              xml.SUBMERCHANT_CATEGORY @sub_mct.business_type
            }
          }
        }
      end
      @req_type = :intfc
      @xml = builder.to_xml
    end

    def send_to_hzyb
      unless @req_type
        @err_code = '01'
        @err_desc = '没有初始化请求数据'
        return
      end
      xml_str = @xml.gsub('[sign]', '')
      xml_utf = xml_str.encode('utf-8', 'gbk')
      sn = sign(xml_utf)
      xml_sn = xml_str.gsub('<SIGNED_MSG></SIGNED_MSG>', "<SIGNED_MSG>#{sn}</SIGNED_MSG>")
      gzip = ActiveSupport::Gzip.compress(xml_sn)
      b64 = Base64.encode64(gzip)
      url = AppConfig.get('hzyb', 'intfc_url')
      if @req_type == :intfc
        url += "/merchantIn/merchantIn"
      else
        url += "/merchantIn/merchantInModify"
      end
      pd = SentPost.new
      begin
        pd.method = 'hz_intfc/' + @req_type.to_s
        pd.sender = @sub_mct
        pd.post_url = url
        pd.post_data = xml_utf.to_s.truncate(2000, omission: '... (to long)')

        resp = HTTParty.post(url, body: b64, headers: {"Content-Type": "text/plain; charset=ISO-8859-1"})
        pd.resp_type = resp.response.inspect
        if resp.body.present?
          txt_gzip = Base64.decode64(resp.body)
          txt = ActiveSupport::Gzip.decompress(txt_gzip)
          txt.force_encoding('gbk')
          txt_no = txt.gsub(/<SIGNED_MSG>(.|\n)*<\/SIGNED_MSG>/, '<SIGNED_MSG></SIGNED_MSG>')
          pd.resp_body = txt_no
          rr = txt.match(/<SIGNED_MSG>((.|\n)*)<\/SIGNED_MSG>/)
          return_key = rr[1]
          txt_no_utf = txt_no.encode('utf-8', 'gbk')
          unless verify(txt_no_utf, return_key)
            @err_code = '20'
            @err_desc = '验签错误'
          end
          xml = Nokogiri::XML(txt_no_utf)
          if xml.xpath("//RET_CODE").text == '0000'
            @err_desc = xml.xpath("//ERR_MSG").text
            if @req_type == :intfc
              @sub_mch.status = 1
              @sub_mch.mch_id = xml.xpath("//SUBMERCHANT_ID").text
              @sub_mch.save!
            end
          else
            @err_code = '20'
            @err_desc = xml.xpath("//ERR_MSG").text
          end
        else
          @err_code = '20'
          @err_desc = '返回值为空'
        end
      rescue => e
        pd.result_message = e.message
        @err_code = '21'
        @err_desc = '连接错误：' + e.message
      end
      pd.save
    end

    def sign(data)
      sign = ''
      begin
        socket = TCPSocket.open('127.0.0.1', 9001)
        socket.write("HzSign\0")
        socket.write(data)
        socket.write("\0")
        sign = socket.read
      rescue => e
        @err_code = '01'
        @err_desc = '系统错误：' + e.message
      end
      sign
    end

    def verify(data, p7_key)
      pkcs7 = OpenSSL::PKCS7.new(Base64.decode64(p7_key))
      pkcs7.verify(pkcs7.certificates, OpenSSL::X509::Store.new, data, OpenSSL::PKCS7::NOVERIFY)
    end

  end
end
