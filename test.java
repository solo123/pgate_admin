
import java.io.BufferedReader;
import java.io.InputStream;
import java.io.InputStreamReader;
import java.io.OutputStream;
import java.io.UnsupportedEncodingException;
import java.net.HttpURLConnection;
import java.net.URL;
import java.util.Arrays;
import java.util.HashMap;
import java.util.Iterator;
import java.util.Map;

import javax.crypto.Cipher;
import javax.crypto.spec.SecretKeySpec;

import org.json.JSONException;
import org.json.JSONObject;

import com.kaifu.util.Utils;



public class test {
	
	public static void main(String[] args) throws Exception{
		
		
		JSONObject json = new JSONObject();
		
		json.put("sendTime", "20160811200238");
		json.put("sendSeqId", "200238");
		json.put("transType", "A001");
		json.put("organizationId", "bjtengshi");
		json.put("payPass", "1");
		
		//json.put("mac",makeMac(json.toString(),"macKey明文"));  //macKey明文由主密钥明文3des解密签到返回的macKey密文得到
		
		String urlPath = "http://61.135.202.242:8020/payform/organization";
		urlPath += "?data=" + json.toString();
		
		System.err.println(urlPath);
		URL url = new URL(urlPath);
		HttpURLConnection connection = (HttpURLConnection) url.openConnection();
		connection.setDoOutput(true);
		connection.setReadTimeout(60 * 1000);
		connection.connect();
		
		OutputStream out = connection.getOutputStream();
		InputStream in = connection.getInputStream();
		
		BufferedReader reader = new BufferedReader(new InputStreamReader(in));
		String line = null;
		String retData = "";
		while((line = reader.readLine()) != null){
			retData += line;
		}
		System.err.println(retData);
		
		json = new JSONObject(retData);
		String terminalInfo = json.getString("terminalInfo");
		
		String macKey = bcd2Str(decrypt3(terminalInfo, "75BC969ED7DE4A6EB225044F87805357"));
		
		json = new JSONObject();
		json.put("fee", "5");
		json.put("cardNo", "6227002392010329805");
		json.put("body", "商户");
		json.put("transType", "B001");
		json.put("callbackUrl", "http://139.196.235.143/apppay/mobile/index.php/notify/WXNotify");
		json.put("idNum", "22058119900908507X");
		json.put("payPass", "1");
		json.put("sendSeqId", "005681");
		json.put("name", "金海振");
		json.put("sendTime", "20160908170055");
		json.put("organizationId", "bjtengshi");
		json.put("notifyUrl", "http://139.196.235.143/apppay/mobile/index.php/notify/WXNotify");
		json.put("transAmt", "1000");
		json.put("mac", makeMac(json.toString(), macKey));
		
		
		urlPath = "http://61.135.202.242:8020/payform/organization";
		urlPath += "?data=" + json.toString();
		
		System.err.println(urlPath);
		url = new URL(urlPath);
		connection = (HttpURLConnection) url.openConnection();
		connection.setDoOutput(true);
		connection.setReadTimeout(60 * 1000);
		connection.connect();
		
		out = connection.getOutputStream();
		in = connection.getInputStream();
		
		reader = new BufferedReader(new InputStreamReader(in));
		line = null;
		retData = "";
		while((line = reader.readLine()) != null){
			retData += line;
		}
		System.err.println(retData);
	}
	
	public static String makeMac(String json,String macKey){
    	Map<String, String> contentData = (Map<String, String>) parserToMap(json);
		String macStr="";
		Object[] key_arr = contentData.keySet().toArray();
		Arrays.sort(key_arr);
		for (Object key : key_arr) {
			Object value = contentData.get(key);
			if (value != null ) {
				if (!key.equals("mac") ) {
					macStr+= value.toString();
				}
			}
		}
		
		String rMac = mac(macStr, macKey);
		return rMac;
	}
	
	public static HashMap<String, String> parserToMap(String s){  
	    Map map=new HashMap();  
	    JSONObject json;
		try {
			json = new JSONObject(s);
			Iterator keys=json.keys();  
		    while(keys.hasNext()){  
		        String key=(String) keys.next();  
		        String value=json.get(key).toString();    
		        map.put(key, value); 
		    }  
		} catch (JSONException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
	    
	    return (HashMap<String, String>)map;  
	}  
	
	
	public static String mac(String macStr,String key){
		String macByte = "";
		try {
			macByte = GenXorData(macStr.getBytes("GBK"),0);
		} catch (UnsupportedEncodingException e1) {
			
			e1.printStackTrace();
		}
		String macAsc=bcd2Str(macByte.getBytes());
		//加密
		try {
			byte[] leftByte=encrypt3(macAsc.substring(0,16), key);
			byte[] macByteAll=new byte[16];
			System.arraycopy(leftByte, 0, macByteAll, 0, 8);
			System.arraycopy(string2Bytes(macAsc.substring(16,32)), 0, macByteAll, 8, 8);
			
			String temp=GenXorData(macByteAll,0);
			byte[] mac=encrypt3(temp, key);
			return bcd2Str(bcd2Str(mac).getBytes()).substring(0,8);
		} catch (Exception e) {
					
			e.printStackTrace();
			return "";
		}
	}   
	
	public static String  GenXorData(byte[] bBuf,int iStart)
	{
		int i = 0 ;
		int nLen = 0 ;
		int nDataLen =  0;
		int nXorDataLen = 0 ;
		byte[] s1 = new byte[8] ;
		byte[] s2 = new byte[8] ;
		byte[] buf = bBuf;
		nDataLen= buf.length;
		nLen = 8 - (nDataLen%8);
		nLen = (nLen == 8) ? 0 : nLen ;
		nXorDataLen = (nDataLen+nLen) ;	//不足8的倍数，用0x00补齐。
		byte[] pBuf = new byte[nXorDataLen];
		
		System.arraycopy(buf, 0, pBuf, 0, nDataLen) ;
		System.arraycopy(pBuf, 0, s1, 0, 8) ;
		for(i = 8; i<nXorDataLen; i+=8)
		{			
			System.arraycopy(pBuf, i, s2, 0, 8) ;
			s1=setxor(s1, s2);
		}
		return bcd2Str(s1);
	}
	public static byte[] setxor(byte[] b1, byte[] b2) {

		byte[] snbyte = new byte[b1.length];
		for (int i = 0, j = 0; i < b1.length; i++, j++) {
			snbyte[i] = (byte) (b1[i] ^ b2[j]);
		}
		return snbyte;
	}
	
 public static byte[] encrypt3(String data, String keyStr)
	        throws Exception
	    {
	    	byte[] keyByte = ASCII_To_BCD(keyStr.getBytes());
	        byte input[] = ASCII_To_BCD(data.getBytes());
	        byte keyBytes[] = new byte[24];
	        System.arraycopy(keyByte, 0, keyBytes, 0, 16);
	        System.arraycopy(keyByte, 0, keyBytes, 16, 8);
	        SecretKeySpec key = new SecretKeySpec(keyBytes, "DESede");
	        Cipher cipher = Cipher.getInstance("DESede/ECB/NOPADDING");
	        cipher.init(1, key);
	        byte cipherText[] = new byte[cipher.getOutputSize(input.length)];
	        int ctLength = cipher.update(input, 0, input.length, cipherText, 0);
	        ctLength += cipher.doFinal(cipherText, ctLength);
	        return cipherText;
	    }

	    public static byte[] decrypt3(String data, String keyStr)
	        throws Exception
	    {
	    	byte[] keyByte = ASCII_To_BCD(keyStr.getBytes());
	        byte input[] = ASCII_To_BCD(data.getBytes());
	        byte keyBytes[] = new byte[24];
	        System.arraycopy(keyByte, 0, keyBytes, 0, 16);
	        System.arraycopy(keyByte, 0, keyBytes, 16, 8);
	        SecretKeySpec key = new SecretKeySpec(keyBytes, "DESede");
	        Cipher cipher = Cipher.getInstance("DESede/ECB/NOPADDING");
	        cipher.init(2, key);
	        byte cipherText[] = new byte[cipher.getOutputSize(input.length)];
	        int ctLength = cipher.update(input, 0, input.length, cipherText, 0);
	        ctLength += cipher.doFinal(cipherText, ctLength);
	        return cipherText;
	    }
	    
	    private static byte asc_to_bcd(byte asc) {
			byte bcd;

			if ((asc >= '0') && (asc <= '9'))
				bcd = (byte) (asc - '0');
			else if ((asc >= 'A') && (asc <= 'F'))
				bcd = (byte) (asc - 'A' + 10);
			else if ((asc >= 'a') && (asc <= 'f'))
				bcd = (byte) (asc - 'a' + 10);
			else
				bcd = (byte) (asc - 48);
			return bcd;
		}

		private static byte[] ASCII_To_BCD(byte[] ascii, int asc_len) {
			byte[] bcd = new byte[asc_len / 2];
			int j = 0;
			for (int i = 0; i < (asc_len + 1) / 2; i++) {
				bcd[i] = asc_to_bcd(ascii[j++]);
				bcd[i] = (byte) (((j >= asc_len) ? 0x00 : asc_to_bcd(ascii[j++])) + (bcd[i] << 4));
			}
			return bcd;
		}

		public static byte[] ASCII_To_BCD(byte[] ascii) {
			int asc_len = ascii.length;
			byte[] bcd = new byte[asc_len / 2];
			int j = 0;
			for (int i = 0; i < (asc_len + 1) / 2; i++) {
				bcd[i] = asc_to_bcd(ascii[j++]);
				bcd[i] = (byte) (((j >= asc_len) ? 0x00 : asc_to_bcd(ascii[j++])) + (bcd[i] << 4));
			}
			return bcd;
		}

		public static String bcd2Str(byte[] bytes) {
			char temp[] = new char[bytes.length * 2], val;

			for (int i = 0; i < bytes.length; i++) {
				val = (char) (((bytes[i] & 0xf0) >> 4) & 0x0f);
				temp[i * 2] = (char) (val > 9 ? val + 'A' - 10 : val + '0');

				val = (char) (bytes[i] & 0x0f);
				temp[i * 2 + 1] = (char) (val > 9 ? val + 'A' - 10 : val + '0');
			}
			return new String(temp);
		}
		
		public static String bytes2Str(byte[] baSrc, int iStart, int length) {
			if ((iStart + length) > baSrc.length)
				return null;

			String sRtn = "";
			for (int i = 0; i < length; i++)
				sRtn += baSrc[iStart + i];

			return sRtn;
		}
		
		public static byte[] string2Bytes(String str) {
			byte[] b = new byte[str.length() / 2];
			for (int i = 0; i < b.length; i++) {
				b[i] = (byte) Integer.parseInt(str.substring(i * 2, i * 2 + 2), 16);
			}
			return b;
		}
	
}
