import tkinter as tk
import matplotlib.pyplot as plt
from matplotlib.backends.backend_tkagg import FigureCanvasTkAgg
import time
import csv
from pyModbusTCP.client import ModbusClient
import random
c = ModbusClient(host="10.0.0.1", port=502, auto_open=True, auto_close=True)

header = ['n', 'volt_flow', 'volt_level', 'volt_pot', 'timeNow']
f = open('dataRafif.csv', 'w', encoding='UTF8', newline='') # open the file in the write mode
writer = csv.writer(f) # create the csv writer
writer.writerow(header) # write the header
timeSampling = 0.05 # dalam detik, min 0.05s
n = 0
#-----plot data-----
def plot_data():
    print("masuk plot data")
    global n,cond, arr_n, arr_volt_level, timeLast
    if (cond==True):
        print(cond)
        timeNow = time.time()
        # condition untuk sampling, jika sudah melebihi time sampling
        if timeNow - timeLast >= timeSampling:
            n = n + 1
            print("timeLast sudah bisa masuk")
            arr_n.append(n)
            volt_flow,volt_level,volt_pot = kontroller()

            arr_volt_level.append(volt_level)

            timeLast = timeNow
            ax.set_xlim(min(arr_n), max(arr_n))
            ax.set_ylim(min(arr_volt_level), max(arr_volt_level))
            # lines = ax.plot(arr_elapse, arr_volt_level, color='green')
            lines.set_xdata(arr_n)
            lines.set_ydata(arr_volt_level)
            # write multiple rows
            writer.writerow([n, volt_flow, volt_level, volt_pot, timeNow])
            print(arr_n)
            print(arr_volt_level)
            canvas.draw()

        window.after(1, plot_data)
def plot_start():
    global cond, start_time, sent
    cond = True
    sent = c.write_multiple_registers(16, [4096, 0])  # list bit pompa dan valve max.4096
    # s.reset_input_buffer()
    print("start mulai yaa")
    # return cond
    window.after(1, plot_data)

def plot_stop():
    global cond, sent
    cond = False
    print("sudah stop yaa")
    sent = c.write_multiple_registers(16, [0, 4096])
    f.close()

def kontroller():
    global volt_flow,volt_level,volt_pot
    regs = c.read_holding_registers(8, 8)  # format: (address,quantity). quantity gabole lebih, tapi boleh kurang
    bit_flow = regs[0]
    volt_flow = 20*bit_flow/65535 - 10

    bit_level = regs[1]
    volt_level = 20*bit_level/65535 - 10

    bit_pot = regs[2]
    volt_pot = 20 * bit_pot / 65535 - 10

    return volt_flow,volt_level,volt_pot

cond = False
timeLast = 0
arr_n = []
arr_volt_level = []


window = tk.Tk()
window.title('GUI Open Loop PCT-100')
window.configure(background = 'light blue')
window.geometry("700x500")

fig = plt.Figure();
ax = fig.add_subplot(111)
ax.set_title('Open Loop Level')
ax.set_xlabel('n ke-')
ax.set_ylabel('Level (V)')
lines = ax.plot([],[])[0]

canvas = FigureCanvasTkAgg(fig, master=window)  # A tk.DrawingArea.
canvas.get_tk_widget().place(x = 10,y=10, width = 600,height = 400)
canvas.draw()
# ----------create button---------
window.update();
start = tk.Button(window, text = "Start", font = ('calbiri',12),command = lambda: plot_start())
start.place(x = 100, y = 450 )

window.update();
stop = tk.Button(window, text = "Stop", font = ('calbiri',12), command = lambda:plot_stop())
stop.place(x = start.winfo_x()+start.winfo_reqwidth() + 20, y = 450)

# window.after(1,plot_data)
window.mainloop()

# greeting = tk.Label(text="Hello, Tkinter")
# greeting.pack()
