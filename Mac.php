<?php

class Mac
{

    public function TripleDESEncodeHex($plaintext)
    {
        $mac_plaintext = $this->getBodyMac($plaintext);

        include_once('Crypt/TripleDES.php');
        $des = new Crypt_TripleDES(CRYPT_DES_MODE_ECB);
        $des->setKey($this->getXuriQuanDESKey());
        return encodeHex($des->encrypt($this->hex2bin($mac_plaintext)));
    }

    function getBodyMac($body)
    {
        //拆分MAC数据源，每组16位hex(8 byte())
        $ds = $this->splitData($body);
        $des = "";
        for ($i = 0; $i < count($ds); $i++) {
            if ($i == 0) {
                $des = encodeHex($ds[$i]);
            } else {
                $des = $this->hexXor($des, encodeHex($ds[$i]));
            }
        }
        return $des;
    }

    public function splitData($hexMacDataSource, $num=8)
    {
        $len = 0;

        $modValue = strlen($hexMacDataSource) % $num;
        if($modValue != 0)
        {
            $hexSrcDataLen = strlen($hexMacDataSource);
            $totalLen = $hexSrcDataLen + ($num - $modValue);
            $hexMacDataSource = str_pad($hexMacDataSource, $totalLen, chr(0));
        }

        $len = strlen($hexMacDataSource) / $num;
        $ds = array();

        for ($i = 0; $i < $len; $i++)
        {
            if (strlen($hexMacDataSource) >= $num)
            {
                $ds[] = substr($hexMacDataSource,0, $num);
                $hexMacDataSource = substr($hexMacDataSource,$num);
            } else
            {
                throw new Exception("填充的数据非法!",6008);
            }
        }
        return $ds;
    }

    public function hexXor($hexStr1, $hexStr2)
    {
        return str_pad(strtoupper(gmp_strval(gmp_xor(gmp_init($hexStr1, 16), gmp_init($hexStr2, 16)), 16)), 16, '0', STR_PAD_LEFT);
    }

    public function hex2bin($hexData)
    {
        $binData = "";
        for ($i = 0; $i < strlen($hexData); $i += 2) {
            $binData .= chr(hexdec(substr($hexData, $i, 2)));
        }
        return $binData;
    }

	function encodeHex($str)  //字符串2hex
	{
		return strtoupper(bin2hex($str));
	}
}