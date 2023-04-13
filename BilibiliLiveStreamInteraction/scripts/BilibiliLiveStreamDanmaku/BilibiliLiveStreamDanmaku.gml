/// @desc 按照时间戳来合并两个弹幕数组并返回
function BlsDanmakuMergeArray(arrDanmakuA, arrDanmakuB) {
	var arrRes = [];
	
	var arrDanmakuALen = array_length(arrDanmakuA);
	var arrDanmakuBLen = array_length(arrDanmakuB);
	
	var len = arrDanmakuALen + arrDanmakuBLen;
	var iA = 0, iB = 0;
	for(var i = 0; i < len; i++) {
		array_push(arrRes
			, iA < arrDanmakuALen
			? (
				iB < arrDanmakuBLen
				? (
					BlsTimelineStringCompare(arrDanmakuA[iA].timeline, arrDanmakuB[iB].timeline) > 0
					? arrDanmakuA[iA++]
					: arrDanmakuB[iB++]
				)
				: arrDanmakuA[iA++]
			)
			: arrDanmakuB[iB++]
		);
	}
	
	return arrRes;
}
