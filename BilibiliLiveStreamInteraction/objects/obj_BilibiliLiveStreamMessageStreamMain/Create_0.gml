/// @desc 需要搭配该项目文件夹下的 BiliLiveApiHandler 来使用

apiUrl = "http://127.0.0.1:42333";
httpId = http_get(apiUrl);

danmakuGetCdMax = 0.5 * game_get_speed(gamespeed_fps); // 0.5秒获取一次
danmakuGetCd = 0;

/// @desc 我的业务逻辑（弹幕处理）
MyBusiness_DANMU_MSG = function(_danmaku) {
	/*
	
	在这里写相关业务逻辑就好，如果不需要的话可以把下面那行 show_debug_message 删去
	
	*/
	show_debug_message("{0}({1}) : {2}", _danmaku.uname, _danmaku.uid, _danmaku.content);
}

/// @desc 我的业务逻辑（礼物赠送）
MyBusiness_SEND_GIFT = function(_gift) {
	/*
	
	在这里写相关业务逻辑就好，如果不需要的话可以把下面那行 show_debug_message 删去
	
	*/
	show_debug_message(_gift);
}
