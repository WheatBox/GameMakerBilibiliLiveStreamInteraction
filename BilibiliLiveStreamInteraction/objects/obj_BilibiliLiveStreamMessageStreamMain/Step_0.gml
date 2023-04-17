if(++danmakuGetCd >= danmakuGetCdMax) {
	danmakuGetCd = 0;
	
	httpId = http_get(apiUrl);
}
