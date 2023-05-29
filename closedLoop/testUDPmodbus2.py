from pyModbusTCP.client import ModbusClient
import time

# import python UDP client
import socket

# create a modbus client
modbusClient = ModbusClient(host="10.0.0.1", port=502, auto_open=True, auto_close=True)

# create UDP client
udpClient = socket.socket(socket.AF_INET, socket.SOCK_DGRAM)


# create ADAM 5000L client
class Adam5000L:
    def __init__(self, modbus: ModbusClient, udp: socket.socket):
        self.client = modbus
        self.udp = udp
        self.udp.settimeout(1)
        # self.udp.setblocking(0)
        self.udp.bind(("0.0.0.0", 5168))

    def readAIs(self, addr, length):
        # AI start at 8
        return self.client.read_holding_registers(addr + 8, length)

    def writeAO(self, addr, value):
        # AO start at 16
        return self.client.write_single_register(addr + 16, value)

    def writeAOs(self, addr, values):
        # AO start at 16
        return self.client.write_multiple_registers(addr + 16, values)


# create Adam5000L client
adam = Adam5000L(modbusClient, udpClient)

# benchmark time
startTime = time.perf_counter()

# read AI 0-1
lastTarget = [1, 1]
while True:

    # get performance time
    ct = time.perf_counter()
    dt = ct - startTime

    if dt < 1:
        target = [0, 0]
    elif dt > 1 and dt < 5:
        target = [4096, 0]
    elif dt > 5:
        target = [0, 0]

    if target != lastTarget:
        adam.writeAOs(0, target)
        lastTarget = target

    if dt > 6:
        break

    # res = adam.readAIs(0, 2)
    # print(dt, res)

    d = adam.udp.recvfrom(1024)
    # convert to int
    data = [int.from_bytes(d[0][i:i + 2], byteorder='big') for i in range(0, len(d[0]), 2)]
    dataAI = data[19:29]

    print(dataAI)

    time.sleep(0.05)