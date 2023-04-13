// Bls = Bilibili Live Stream

/// @desc 因为可能使用会比较频繁而且散，所以就不做成 constructor 了，就直接写了个 return 在里面
function MakeBlsTimeline(_timelineString) {
	return {
		m_timelineString : _timelineString,
		
		m_year : real(string_copy(_timelineString, 1, 4)),
		m_month : real(string_copy(_timelineString, 6, 2)),
		m_day : real(string_copy(_timelineString, 9, 2)),
		m_hour : real(string_copy(_timelineString, 12, 2)),
		m_minute : real(string_copy(_timelineString, 15, 2)),
		m_second : real(string_copy(_timelineString, 18, 2)),
	}
}

/// @desc 比较两个 BlsTimeline，返回-1表示参数A时间较新，返回0表示两时间相等，返回1表示参数B时间较新
function BlsTimelineCompare(_blsTimelineA, _blsTimelineB) {
	if(_blsTimelineA.m_year > _blsTimelineB.m_year)
		return -1;
	if(_blsTimelineA.m_year < _blsTimelineB.m_year)
		return 1;
	
	if(_blsTimelineA.m_month > _blsTimelineB.m_month)
		return -1;
	if(_blsTimelineA.m_month < _blsTimelineB.m_month)
		return 1;
	
	if(_blsTimelineA.m_day > _blsTimelineB.m_day)
		return -1;
	if(_blsTimelineA.m_day < _blsTimelineB.m_day)
		return 1;
	
	if(_blsTimelineA.m_hour > _blsTimelineB.m_hour)
		return -1;
	if(_blsTimelineA.m_hour < _blsTimelineB.m_hour)
		return 1;
	
	if(_blsTimelineA.m_minute > _blsTimelineB.m_minute)
		return -1;
	if(_blsTimelineA.m_minute < _blsTimelineB.m_minute)
		return 1;
	
	if(_blsTimelineA.m_second > _blsTimelineB.m_second)
		return -1;
	if(_blsTimelineA.m_second < _blsTimelineB.m_second)
		return 1;
	
	return 0;
}

function BlsTimelineStringCompare(_timelineStringA, _timelineStringB) {
	return BlsTimelineCompare(MakeBlsTimeline(_timelineStringA), MakeBlsTimeline(_timelineStringB));
}
