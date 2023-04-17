var _arr = [1, 30003, 30000];
for(var i = 0; i < array_length(_arr); i++) {
	var _spr = GetBlsGiftPngSpr(_arr[i]);
	if(_spr != -1) {
		draw_sprite(_spr, 0, 160 * i, 0);
		draw_text(160 * i, 160, string(sprite_get_width(_spr)) + "x" + string(sprite_get_height(_spr)));
	} else {
		draw_text(160 * i, 0, "-1");
	}
}
