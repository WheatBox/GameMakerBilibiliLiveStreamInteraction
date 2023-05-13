// B站直播API：https://github.com/lovelyyoshino/Bilibili-Live-API

/* ------------------------ */
// 在此处设定房间号
const ROOMID = 960890;

/* ------------------------ */

const WebSocket = require('ws');
const pako = require('pako');

var gArrData = [];

const textEncoder = new TextEncoder('utf-8');
const textDecoder = new TextDecoder('utf-8');

const readInt = function(buffer,start,len){
	let result = 0
	for(let i=len - 1;i >= 0;i--){
		result += Math.pow(256,len - i - 1) * buffer[start + i]
	}
	return result
}

const writeInt = function(buffer,start,len,value){
	let i=0
	while(i<len){
		buffer[start + i] = value/Math.pow(256,len - i - 1)
		i++
	}
}

const encode = function(str,op){
	let data = textEncoder.encode(str);
	let packetLen = 16 + data.byteLength;
	let header = [0,0,0,0,0,16,0,1,0,0,0,op,0,0,0,1]
	writeInt(header,0,4,packetLen)
	return (new Uint8Array(header.concat(...data))).buffer
}

const zlib = require('zlib');
const { stringify } = require('querystring');

const decoder = function (blob) {
	let buffer = new Uint8Array(blob)
	let result = {}
	result.packetLen = readInt(buffer, 0, 4)
	result.headerLen = readInt(buffer, 4, 2)
	result.ver = readInt(buffer, 6, 2)
	result.op = readInt(buffer, 8, 4)
	result.seq = readInt(buffer, 12, 4)
	if (result.op === 5) {
		result.body = []
		let offset = 0;
		while (offset < buffer.length) {
		let packetLen = readInt(buffer, offset + 0, 4)
		let headerLen = 16// readInt(buffer,offset + 4,4)
		let data = [];
		if (result.ver == 2) {
			data = buffer.slice(offset + headerLen, offset + packetLen);
			let newBuffer = zlib.inflateSync(new Uint8Array(data));
			const obj = decoder(newBuffer);
			const body = obj.body;
			result.body = result.body.concat(body);
		} else {
			data = buffer.slice(offset + headerLen, offset + packetLen);
			let body = textDecoder.decode(data);
			if (body) {
			result.body.push(JSON.parse(body));
			}
		}
		if(data.len > 0) {
			let body = textDecoder.decode(pako.inflate(data));
			if (body) {
				result.body.push(JSON.parse(body.slice(body.indexOf("{"))));
			}
			}
		offset += packetLen;
		}
	} else if (result.op === 3) {
		result.body = {
		count: readInt(buffer, 16, 4)
		};
	}
	return result;
}

const decode = function (blob) {
	return new Promise(function (resolve, reject) {
		const result = decoder(blob);
		resolve(result)
	});
}

const ws = new WebSocket('wss://broadcastlv.chat.bilibili.com/sub');
ws.onopen = function () {
	ws.send(encode(JSON.stringify({
		roomid: ROOMID
	}), 7));
};

setInterval(function () {
		ws.send(encode('', 2));
	}, 30000);

ws.onmessage = async function (msgEvent) {
	const packet = await decode(msgEvent.data);
	switch (packet.op) {
	case 8:
		console.log('加入房间');
		break;
	case 5:
		packet.body.forEach((body)=>{
		switch (body.cmd) {
			case 'DANMU_MSG':
				var mes = {'cmd': 'DANMU_MSG',
					'uid': body.info[2][0],
					'uname': body.info[2][1],
					'content': body.info[1]
				};
				console.log(`${mes.uid} ${mes.uname}: ${mes.content}`);
				gArrData.push(JSON.stringify(mes));
				break;
				
			case 'SEND_GIFT':
				var mes = {'cmd': 'SEND_GIFT',
					'uid': body.data.uid,
					'uname': body.data.uname,
					'price': body.data.price,
					'num': body.data.num,
					'giftId': body.data.giftId,
					'giftName': body.data.giftName
				};
				console.log(`${mes.uname} 发送礼物 ${mes.num} 个 ${mes.giftName}`);
				gArrData.push(JSON.stringify(mes));
				break;
			default:
			// console.log(body);
		}
		})
		break;
	default:
		// console.log(packet);
	}
};

http = require('http');

http.createServer((req, res) => {
	res.write("[" + gArrData.toString() + "]");
	res.end();

	gArrData = [];
}).listen(42333);
