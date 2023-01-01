from pymodbus.client import ModbusTcpClient

print("mulai read: ")
client = ModbusTcpClient('127.0.0.1')
client.write_coil(1, True)
result = client.read_coils(1,1)
print(result.bits[0])
print(result.bits[1])
print(result.bits[2])
client.close()
print("selesai")