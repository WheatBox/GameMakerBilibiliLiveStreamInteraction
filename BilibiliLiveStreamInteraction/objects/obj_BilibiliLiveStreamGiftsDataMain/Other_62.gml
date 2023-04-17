if(async_load[? "id"] == httpId) {
	if(async_load[? "status"] == 0) {
		var sourceDanmakuData = json_parse(async_load[? "result"]);
		// show_debug_message(sourceDanmakuData);
		
		TransToBlsGiftsDataArray(sourceDanmakuData.data);
	} else {
		show_debug_message(async_load[? "http_status"]);
	}
}
