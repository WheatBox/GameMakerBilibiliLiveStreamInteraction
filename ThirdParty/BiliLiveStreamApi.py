# 摘抄并修改自 https://www.bilibili.com/video/BV1p8411s7qN 中的代码

import brotli
import flask
import json
import queue
import struct
import threading
import time
import websocket

# ROOM_ID = 27050582
# ROOM_ID = 21622811
ROOM_ID = 960890
BILIBILI_HEAD = '>ihhii'
BILIBILI_HEAD_LEN = struct.calcsize(BILIBILI_HEAD)

app = flask.Flask(__name__)


class BilibiliDanmu:
    def __init__(self, data, header_length = BILIBILI_HEAD_LEN, protocol_version = 0, operation = 7, sequence_id = 1):
        if type(data) == str:
            self.data = data.encode('utf-8')
            self.packet_length = len(data) + BILIBILI_HEAD_LEN
            self.header_length = header_length
            self.protocol_version = protocol_version
            self.operation = operation
            self.sequence_id = sequence_id
        elif type(data) == bytes:
            self.packet_length, self.header_length, self.protocol_version, self.operation, self.sequence_id, self.data = self.decode(data)
        if self.packet_length != len(self.data) + self.header_length:
            self.other_data = self.data[self.packet_length - self.header_length:]
            self.data = self.data[:self.packet_length - self.header_length]
        else:
            self.other_data = None
    
    def encode(self):
        return struct.pack(BILIBILI_HEAD, self.packet_length, self.header_length, self.protocol_version, self.operation, self.sequence_id) + self.data
    
    @staticmethod
    def decode(data):
        packet_length, header_length, protocol_version, operation, sequence_id = struct.unpack(BILIBILI_HEAD, data[:BILIBILI_HEAD_LEN])
        if protocol_version == 3:
            data = brotli.decompress(data[BILIBILI_HEAD_LEN:])
            packet_length, header_length, protocol_version, operation, sequence_id = struct.unpack(BILIBILI_HEAD, data[:BILIBILI_HEAD_LEN])
        return packet_length, header_length, protocol_version, operation, sequence_id, data[BILIBILI_HEAD_LEN:]

class BilibiliWebsocket:
    def __init__(self, room_id):
        self.room_id = room_id
        self.ws = websocket.WebSocketApp("wss://broadcastlv.chat.bilibili.com/sub", on_open=self.on_open, on_message=self.on_message)
        self.danmu_list = queue.Queue()
    
    def put_danmu(self, danmu):
        if danmu.operation != 5:
            return
        self.danmu_list.put(danmu.data.decode('utf-8'))
    
    def get_danmu(self):
        danmu_list = []
        while self.danmu_list.empty() is False:
            danmu_list.append(self.danmu_list.get())
        return danmu_list

    def on_message(self, ws,  message):
        danmu = BilibiliDanmu(message)
        self.put_danmu(danmu)
        while danmu.other_data:
            danmu = BilibiliDanmu(danmu.other_data)
            self.put_danmu(danmu)
    
    def on_open(self, ws):
        ws.send(BilibiliDanmu(json.dumps({
            "protover": 3,
            "roomid": self.room_id,
            "platform": "web",
            "type": 2,
        })).encode())
    
    def heartbeat(self):
        while True:
            self.ws.send(BilibiliDanmu(json.dumps({}), operation=2).encode())
            time.sleep(10)
    
    def start(self):
        threading.Thread(target = self.ws.run_forever, kwargs = {"ping_timeout": 30}).start()
        time.sleep(1)
        threading.Thread(target=self.heartbeat).start()

@app.route('/api/danmu')
def api_danmu():
    return_list = []
    for danmu in danmu_ws.get_danmu():
        danmu = json.loads(danmu)
        if danmu['cmd'].split(':')[0] == 'DANMU_MSG' or danmu['cmd'] == 'DANMU_MSG':
            return_list.append({'cmd': 'DANMU_MSG',
                                'uid': danmu['info'][2][0],
                                'uname': danmu['info'][2][1],
                                'content': danmu['info'][1]
                                })
        elif danmu['cmd'] == 'SEND_GIFT':
            return_list.append({'cmd': danmu['cmd'],
                                'uid': danmu['data']['uid'],
                                'uname': danmu['data']['uname'],
                                'price': danmu['data']['price'],
                                'num': danmu['data']['num'],
                                'giftId': danmu['data']['giftId'],
                                'giftName': danmu['data']['giftName']
                                })
    return flask.jsonify({"data": return_list})

danmu_ws = BilibiliWebsocket(ROOM_ID)
danmu_ws.start()
app.run(host = '0.0.0.0', port = 18080)
