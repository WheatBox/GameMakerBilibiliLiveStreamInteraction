globalvar gArrBlsGiftsData, gArrBlsGiftsDataLen;
gArrBlsGiftsData = [];
gArrBlsGiftsDataLen = 0;

function TransToBlsGiftsDataArray(_sourceDataArr) {
	var len = array_length(_sourceDataArr);
	for(var i = 0; i < len; i++) {
		gArrBlsGiftsData[_sourceDataArr[i].id] = _sourceDataArr[i];
	}
	gArrBlsGiftsDataLen = array_length(gArrBlsGiftsData);
}

function GetBlsGiftPngSpr(_giftId) {
	if(_giftId < 0 || _giftId >= gArrBlsGiftsDataLen) {
		return -1;
	}
	
	var _spr = -1;
	if(gArrBlsGiftsData[_giftId] != undefined && gArrBlsGiftsData[_giftId] != 0) {
		if(gArrBlsGiftsData[_giftId][$ "spr"] == undefined) {
			_spr = sprite_add(gArrBlsGiftsData[_giftId].img, 0, false, false, 0, 0);
			gArrBlsGiftsData[_giftId][$ "spr"] = _spr;
		} else {
			_spr = gArrBlsGiftsData[_giftId].spr;
		}
	}
	return _spr;
}
