/// @desc 十六进制 转换 十进制
/// @param {string} str 输入一个 16进制 字符串
/// @returns {real} 返回一个 10进制 数字
function HEXtoDEC(str) {
	var temp = "";
	var j = 0;
	var res = 0;
	
	for(var i = string_length(str); i > 0; i--) {
		var t = string_char_at(str, i);
		var m = 0;
		switch(t) {
			case "0":
			case "1":
			case "2":
			case "3":
			case "4":
			case "5":
			case "6":
			case "7":
			case "8":
			case "9":
				m = real(t);
				break;
			case "A":
			case "a":
				m = 10;
				break;
			case "B":
			case "b":
				m = 11;
				break;
			case "C":
			case "c":
				m = 12;
				break;
			case "D":
			case "d":
				m = 13;
				break;
			case "E":
			case "e":
				m = 14;
				break;
			case "F":
			case "f":
				m = 15;
				break;
		}
		res += m * power(16, j);
		j++;
	}
	
	return res;
}

/// @desc 十进制 转换 十六进制
/// @param {real} num 输入一个 10进制 数字
/// @param {real} _minLen 返回的最小长度，不足这个长度会在开头以"0"补齐
/// @returns {string} 返回一个 16进制 字符串
function DECtoHEX(num, _minLen = 1) {
	if(num < 0) {
		return "ERROR!";
	}
	
	if(num == 0) {
		var res0 = "0";
		for(var i = 1; i < _minLen; i++) {
			res0 += "0";
		}
		return res0;
	}
	
	var n = num, m; // n 表示 商，m 表示 余数
	var res = "";
	
	while(n != 0) {
		m = n % 16;
		n = floor(n / 16);
		
		if(m < 10) {
			res += string(m);
		} else {
			switch(m) {
				case 10:
					res += "a";
					break;
				case 11:
					res += "b";
					break;
				case 12:
					res += "c";
					break;
				case 13:
					res += "d";
					break;
				case 14:
					res += "e";
					break;
				case 15:
					res += "f";
					break;
			}
		}
	}
	
	var resFinal = "";
	for(var i = string_length(res); i > 0; i--) {
		resFinal += string_char_at(res, i);
	}
	
	var _patchLen = _minLen - string_length(resFinal);
	for(var i = 0; i < _patchLen; i++) {
		resFinal = "0" + resFinal;
	}
	
	return resFinal;
}
