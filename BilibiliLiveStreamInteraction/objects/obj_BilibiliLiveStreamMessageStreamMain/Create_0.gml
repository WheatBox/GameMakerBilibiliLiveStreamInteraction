/// @desc 需要搭配该项目文件夹下的 BiliLiveStreamApi.py 文件来使用

apiUrl = "http://127.0.0.1:18080/api/danmu";
httpId = http_get(apiUrl);

danmakuGetCdMax = 0.5 * game_get_speed(gamespeed_fps); // 0.5秒获取一次
danmakuGetCd = 0;

/// @desc 我的业务逻辑
MyBusiness_DANMU_MSG = function(_danmaku) {
	/*
	
	在这里写相关业务逻辑就好，如果不需要的话可以把下面那行 show_debug_message 删去
	
	*/
	show_debug_message("{0}({1}) : {2}", _danmaku.uname, _danmaku.uid, _danmaku.content);
}
