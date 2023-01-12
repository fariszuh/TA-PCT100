import tkinter as tk
import matplotlib.pyplot as plt
from matplotlib.backends.backend_tkagg import FigureCanvasTkAgg
import time
import csv
from pyModbusTCP.client import ModbusClient
import random
c = ModbusClient(host="10.0.0.1", port=502, auto_open=True, auto_close=True)

header = ['n','timestamp','volt_level','volt_flow','dvolt_flow','']
writer.writerow([n, timeNow-start_time, volt_level, volt_flow, volt_flow-volt_flow_last,])

f = open('data Closed Loop Khoiruz.csv', 'w', encoding='UTF8', newline='') # open the file in the write mode
writer = csv.writer(f) # create the csv writer
writer.writerow(header) # write the header
timeSampling = 0.05 # dalam detik, min 0.05s
n = 0 # tidak boleh nol agar index tidak e[-1]
# --------INISIASI Variabel PID----------
SP = 10
e=[0.0, 0.0]
# e[0]=0 # initial condition error, iterasi
sum_e=[0.0, 0.0]
de=[0.0, 0.0]
volt_flow = 0

kp = 68
ki = 2
kd = 10

#-----plot data-----
def plot_data():
    # print("masuk plot data")
    global n,cond, arr_n, arr_volt_level, timeLast, sent
    if (cond==True):
        # print(cond)
        timeNow = time.time()
        # condition untuk sampling, jika sudah melebihi time sampling
        if timeNow-timeLast >= timeSampling:
            n = n + 1
            # print("timeLast sudah bisa masuk")
            arr_n.append(n)
            volt_flow,volt_level,volt_pot = kontroller()
            volt_flow_last = volt_flow
            arr_volt_level.append(volt_level)

            timeLast = timeNow
            ax.set_xlim(min(arr_n), max(arr_n))
            ax.set_ylim(min(arr_volt_level), max(arr_volt_level))
            # lines = ax.plot(arr_elapse, arr_volt_level, color='green')
            lines.set_xdata(arr_n)
            lines.set_ydata(arr_volt_level)
            # write multiple rows
            # print("v LT: " + str(volt_level) + " V")
            print("level: " + str(volt_level) + " cm")
            writer.writerow([n, volt_flow, volt_level, timeNow-start_time])
            # print(arr_n)
            # print(arr_volt_level)
            # time.sleep(timeSampling)
            canvas.draw()
        window.after(1, plot_data)
def plot_start():
    global cond, start_time
    cond = True
    start_time = time.time()
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
    global volt_flow,volt_level,volt_pot, sent,n, sinyal_level
    regs = c.read_holding_registers(8, 8)  # format: (address,quantity). quantity gabole lebih, tapi boleh kurang
    bit_flow = regs[0]
    volt_flow = 20*bit_flow/65535 - 10

    bit_level = regs[1]
    # volt_level = (20 * bit_level / 65535 - 10)
    volt_level = 1.7055517310856645*(20*bit_level/65535 - 10) + 4.80943785889385

    bit_pot = regs[2]
    volt_pot = (20 * bit_pot / 65535 - 10)
    print(n)
    print(e[n])
    e[n] = SP - volt_level
    sum_e[n] = sum_e[n] + e[n]*timeSampling
    de[n] = (e[n] - e[n-1])/timeSampling

    P = kp*e[n]
    I = ki*sum_e[n]
    D = kd*de[n]
    uPID = P+I+D

    sinyal_level= 0.586320532982868*uPID - 2.819872168774626  # volt sinyal kirim level
    bit_uPID = 4096*sinyal_level/10
    if bit_uPID > 4096:
        bit_uPID = 4096
    if bit_uPID < 0:
        bit_uPID = 0

    e.append(e[n])
    sum_e.append(e[n])
    de.append(e[n])

    sent = c.write_multiple_registers(16, [int(bit_uPID), 0])  # list bit pompa dan valve max.4096
    return volt_flow,volt_level,volt_pot

cond = False
timeLast = 0
arr_n = []
arr_volt_level = []


window = tk.Tk()
window.title('GUI Closed Loop PCT-100')
window.configure(background = 'light blue')
window.geometry("700x500")

fig = plt.Figure();
ax = fig.add_subplot(111)
ax.set_title('Closed Loop Level')
ax.set_xlabel('n ke-')
ax.set_ylabel('Level (cm)')
# ax.set_ylabel('Level (V)')
lines = ax.plot([],[])[0]

canvas = FigureCanvasTkAgg(fig, master=window)  # A tk.DrawingArea.
canvas.get_tk_widget().place(x = 10,y=10, width = 600,height = 400)
canvas.draw()
# ----------create button---------
window.update();
start = tk.Button(window, text = "Start", font = ('calibri',12),command = lambda: plot_start())
start.place(x = 100, y = 450 )

window.update();
stop = tk.Button(window, text = "Stop", font = ('calibri',12), command = lambda:plot_stop())
stop.place(x = start.winfo_x()+start.winfo_reqwidth() + 20, y = 450)

# window.after(1,plot_data)
window.mainloop()

# greeting = tk.Label(text="Hello, Tkinter")
# greeting.pack()
