apiUrl = "https://api.live.bilibili.com/xlive/web-room/v1/dM/gethistory?roomid=27050582";
// apiUrl = "https://api.live.bilibili.com/xlive/web-room/v1/dM/gethistory?roomid=21622811";
httpId = http_get(apiUrl);

danmakuGetCdMax = 3 * game_get_speed(gamespeed_fps); // 3秒获取一次，因为实测发现所使用的API在服务端那里是3秒更新一次的
danmakuGetCd = 0;

newestDanmaku = undefined; // 用于每次接收数据的时候确定比起前次数据来说的新数据的位置
// 注意该变量不能用于其它用途

/// @desc 我的业务逻辑
MyBusiness = function(_danmaku) {
	/*
	
	在这里写相关业务逻辑就好，如果不需要的话可以把下面那行 show_debug_message 删去
	
	*/
	show_debug_message("{0} {1} : {2}", _danmaku.timeline, _danmaku.nickname, _danmaku.text);
}
