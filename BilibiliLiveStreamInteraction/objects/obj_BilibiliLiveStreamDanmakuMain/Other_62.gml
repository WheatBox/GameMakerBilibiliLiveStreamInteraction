if(async_load[? "id"] == httpId) {
    if(async_load[? "status"] == 0) {
		var sourceDanmakuData = json_parse(async_load[? "result"]);
		// show_debug_message(sourceDanmakuData);
		
		var arrNewDanmaku = [];
		
		var arrDanmaku = sourceDanmakuData.data.room;
		
		if(newestDanmaku != undefined) {
			var i, len = array_length(arrDanmaku);
			for(i = len - 1; i >= 0; i--) { // 找出首条新数据的位置
				var _timeCmpRes = BlsTimelineStringCompare(arrDanmaku[i].timeline, newestDanmaku.timeline);
				if(_timeCmpRes == 0) {
					if(arrDanmaku[i].nickname == newestDanmaku.nickname && arrDanmaku[i].text == newestDanmaku.text) {
						break;
					}
				} else if(_timeCmpRes > 0) { // 理论上来说这种情况并不会出现，但还是写了比较保险
					break;
				}
			}
			i++; // 写后面代码的时候别忘了考虑这一句
			
			if(i < len) {
				array_copy(arrNewDanmaku, 0, arrDanmaku, i, len - i + 1);
			}
		} else {
			array_copy(arrNewDanmaku, 0, arrDanmaku, 0, array_length(arrDanmaku));
		}
		
		var lenNew = array_length(arrNewDanmaku);
		if(lenNew > 0) {
			for(var i = 0; i < lenNew; i++) {
				MyBusiness(arrNewDanmaku[i]);
			}
			
			newestDanmaku = array_last(arrDanmaku);
		}
	} else {
		show_debug_message(async_load[? "http_status"]);
	}
}
