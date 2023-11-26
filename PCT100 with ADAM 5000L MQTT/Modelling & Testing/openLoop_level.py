from pyModbusTCP.client import ModbusClient
import random
import matplotlib
import matplotlib.pyplot as plt
from matplotlib.figure import Figure
from matplotlib.backends.backend_tkagg import FigureCanvasTkAgg
import tkinter as tk
import time

start = time.time()
cond = False
# TCP auto connect on modbus request, close after it
c = ModbusClient(host="10.0.0.1", port=502, auto_open=True, auto_close=True)
# SP NOISE POMPA & DRAIN VALVE
volt_pompa = 10  # max tegangan untuk pompa
volt_valve = 9
# SP OUTER LOOP (LEVEL yang DIHARAPKAN)\
SP_level = 10
#-----Main GUI code-----
root = tk.Tk()
root.title('Real Time Plot')
root.configure(background = 'light blue')
root.geometry("700x500") # set the window size
#------create Plot object on GUI----------
# add figure canvas
fig = Figure();
ax = fig.add_subplot(111)
ax.set_title('Serial Data');
ax.set_xlabel('Sample')
ax.set_ylabel('Voltage')
ax.set_xlim(0,100)
ax.set_ylim(-0.5,6)

def plot_data():
    global cond, data
    if (cond == True):
        a = s.readline()
        a.decode()
        if (len(data) < 100):
            data = np.append(data, float(a[0:4]))
        else:
            data[0:99] = data[1:100]
            data[99] = float(a[0:4])
        lines.set_xdata(np.arange(0, len(data)))
        lines.set_ydata(data)
        canvas.draw()
    root.after(1, plot_data)

def plot_start():
    global cond
    cond = True
    s.reset_input_buffer()
def plot_stop():
    global cond
    cond = False
# indent: tab/shift+tab, comment: ctrl+/
while True:
    # NOISE POMPA & DRAIN VALVE diabaikan, hanya noise pompa yang dipakai
    bit_pompa = int(volt_pompa * 4096 / 10)  # mangubah besaran volt ke bit max 4096

    # READ FEEDBACK SIGNAL-----------------
    regs = c.read_holding_registers(8, 8)  # format: (address,quantity). quantity gabole lebih, tapi boleh kurang
    bit_flow = regs[0]
    volt_flow = (20*bit_flow/65535) - 10
    bit_level = regs[1]
    volt_level = (20*bit_level/65535) - 10

    # CONTROLLER OUTER LOOP/LEVEL

    # CONTROLLER INNER LOOP/FLOW

    # SEND CONTROL SIGNAL------------------
    sent = c.write_multiple_registers(16, [0, 0])  # list bit pompa dan valve max.4096

    print(volt_level)

    end = time.time()
    elapsed = int(end - start)

    lines = ax.plot([], [])[0]
    canvas = FigureCanvasTkAgg(fig, master=root)  # A tk.DrawingArea.
    canvas.get_tk_widget().place(x=10, y=10, width=500, height=400)
    canvas.draw()
    # plt.plot(elapsed, volt_level)
    # plt.show()