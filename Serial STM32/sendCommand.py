import serial
import serial.tools.list_ports as port_list
import time


ports = list(port_list.comports())
print(ports[0].device)
port = ports[0].device
baudrate = 115200
# serialPort = serial.Serial(port=port, baudrate=baudrate,bytesize=8, timeout=1, stopbits=serial.STOPBITS_ONE)
serialPort = serial.Serial(port=port, baudrate=baudrate)
serialString = ""
# serialPort.write(bytes.fromhex("A551F6"))
# serialPort.write(bytes(b'start hahahaha123'))
# serialString = serialPort.read()
# print(serialString)
serialPort.write(b'[SP=1000],[KP=0.34],[KI=-2.55]')

while True:
    try:
        # serialPort.reset_input_buffer()
        # serialPort.reset_output_buffer()
        # serialString = serialPort.read(10).hex()
        serialString = serialPort.readline()
        # serialPort.write(bytes(b'[SP=500],[KP=0.34],[KI=-2.55]'))
        print(serialString)

        # time.sleep(1)
    #
    # try:
    #     data_masuk = ser.readline()
    #     print(data_masuk)
    #
    except KeyboardInterrupt:
        break
    # except ser.SerialTimeoutException:
    #     print('Data could not be read')
    # time.sleep(1)
    str_data_masuk = str(serialString)
    # serialPort.write(bytes.fromhex("A551F6"))

serialPort.close()