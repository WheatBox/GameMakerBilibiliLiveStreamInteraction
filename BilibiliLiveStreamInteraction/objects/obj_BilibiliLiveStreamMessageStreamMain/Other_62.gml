if(async_load[? "id"] == httpId) {
	if(async_load[? "status"] == 0) {
		var sourceDanmakuData = json_parse(async_load[? "result"]);
		// show_debug_message(sourceDanmakuData);
		
		var len = array_length(sourceDanmakuData);
		for(var i = 0; i < len; i++) {
			switch(sourceDanmakuData[i].cmd) {
				case "DANMU_MSG":
					MyBusiness_DANMU_MSG(sourceDanmakuData[i]);
					break;
				case "SEND_GIFT":
					MyBusiness_SEND_GIFT(sourceDanmakuData[i]);
					break;
			}
		}
	} else {
		show_debug_message(async_load[? "http_status"]);
	}
}
