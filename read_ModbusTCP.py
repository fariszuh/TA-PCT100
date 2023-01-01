from pyModbusTCP.client import ModbusClient
import random

# TCP auto connect on first modbus request
# c = ModbusClient(host="localhost", port=502, unit_id=1, auto_open=True)
# TCP auto connect on modbus request, close after it
c = ModbusClient(host="10.0.0.1", port=502, auto_open=True, auto_close=True)
# SP NOISE POMPA & DRAIN VALVE
volt_pompa = 9 #max tegangan untuk pompa
volt_valve = 9
# SP OUTER LOOP (LEVEL yang DIHARAPKAN)\
SP_level = 25

# indent: tab/shift+tab, comment: ctrl+/
while True:
    # NOISE POMPA -------- memberikan disturbance white noise AO max range: 4096
    volt_dist_pompa = volt_pompa + random.uniform(-1, 1) # noise drain valve
    bit_dist_pompa = int(volt_dist_pompa * 4096/10) # mangubah besaran volt ke bit max 4096
    # print(bit_dist_pompa)

    # NOISE VALVE -------- memberikan disturbance white noise AO max range: 4096
    volt_dist_valve = volt_valve + random.uniform(-1, 1)  # noise drain valve
    bit_dist_valve = int(volt_dist_valve * 4096 / 10)  # mangubah besaran volt ke bit max 4096
    # print(bit_dist_pompa)

    # READ FEEDBACK SIGNAL-----------------
    regs = c.read_holding_registers(8,8) #format: (address,quantity). quantity gabole lebih, tapi boleh kurang
    bit_flow = regs[0]
    volt_flow = (bit_flow - 32767)*10/65535 # RUMUS INI SALAH

    bit_level = regs[1]
    volt_level = (bit_level - 32767) * 10 / 65535 # RUMUS INI SALAH

    # CONTROLLER OUTER LOOP/LEVEL


    # CONTROLLER INNER LOOP/FLOW

    # SEND CONTROL SIGNAL------------------
    sent = c.write_multiple_registers(16, [0, 4096])  # list bit pompa dan valve max.4096

    print(bit_dist_pompa)
    # volt = (regs[0] - 32767)*10/65535
    # if regs:
    #     print(regs)
    # else:
    #     print("read error")

    # if c.write_multiple_registers(9, [44]):
    #     print("write ok")
    # else:
    #     print("write error")