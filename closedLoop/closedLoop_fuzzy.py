import tkinter as tk
import matplotlib.pyplot as plt
from matplotlib.backends.backend_tkagg import FigureCanvasTkAgg
import time
import csv
from pyModbusTCP.client import ModbusClient
import random
from skfuzzy import gaussmf, trimf
import numpy as np

c = ModbusClient(host="10.0.0.1", port=502, auto_open=True, auto_close=True)

header = ['n', 'volt_flow', 'input_level', 'volt_pot', 'timestamp']
f = open('dataRafif_FLC.csv', 'w', encoding='UTF8', newline='') # open the file in the write mode
writer = csv.writer(f) # create the csv writer
writer.writerow(header) # write the header
timeSampling = 0.05 # dalam detik, min 0.05s
n = 0 # tidak boleh nol agar index tidak e[-1]
# --------INISIASI Variabel FLC----------
SP = 10 # SP level dlm cm
e=[0.0]
e_np = np.array([0,0])
# e[0]=0 # initial condition error, iterasi

de=[0.0]
de_np = np.array([0,0])


#-----plot data-----
def plot_data():
    # print("masuk plot data")
    global n,cond, arr_n, arr_volt_level, timeLast, sent
    if (cond==True):
        # print(cond)
        timeNow = time.time()
        # condition untuk sampling, jika sudah melebihi time sampling
        if True:
            n = n + 1
            # print("timeLast sudah bisa masuk")
            arr_n.append(n)
            volt_flow,input_level,volt_pot = kontroller()

            arr_volt_level.append(input_level)

            timeLast = timeNow
            ax.set_xlim(min(arr_n), max(arr_n))
            ax.set_ylim(min(arr_volt_level), max(arr_volt_level))
            # lines = ax.plot(arr_elapse, arr_volt_level, color='green')
            lines.set_xdata(arr_n)
            lines.set_ydata(arr_volt_level)
            # write multiple rows
            # print("v LT: " + str(volt_level) + " V")
            print("level: " + str(input_level) + " cm ; volt pump: " + str(sinyal_level) + " VDC")
            writer.writerow([n, volt_flow, input_level, volt_pot, timeNow-start_time])
            # print(arr_n)
            # print(arr_volt_level)
            time.sleep(timeSampling)
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
    global volt_flow,input_level,volt_pot, sent,n, sinyal_level, input_flow, e_np, de_np
    regs = c.read_holding_registers(8, 8)  # format: (address,quantity). quantity gabole lebih, tapi boleh kurang

    bit_flow = regs[0]
    volt_flow = 20*bit_flow/65535 - 10
    input_flow = 0.27*volt_flow # in lt/min

    bit_level = regs[1]
    # volt_level = (20 * bit_level / 65535 - 10)
    volt_level = 20*bit_level/65535 - 10
    input_level = 1.7055517310856645*volt_level + 4.80943785889385

    # bit_pot = regs[2]
    # volt_pot = (20 * bit_pot / 65535 - 10)
    # print(n)
    # e[n] = (SP - input_level)
    e.append(SP - input_level)
    # sum_e[n] = sum_e[n] + e[n]*timeSampling
    # de[n] = (e[n] - e[n-1])/timeSampling
    de.append((e[n] - e[n-1])/timeSampling)
    miu = 0
    perbandingan = 0
    total_miu = 0
    perbandingan_e = []
    perbandingan_de = []
    total_perbandingan = 0
    total_miu = 0

    efuzzy = np.array(e)
    defuzzy = np.array(de)
    # --- Membership output: triangle--------
    cf = -20  # close fast
    cs = -10  # close slow
    nc = 0  # no change
    os = 10  # open slow
    of = 20  # open fast
    # --- Membership input error level: triangle --------
    e_l = trimf(efuzzy, [-4, 1, 5])[n]  # error low
    e_ok = trimf(efuzzy, [1, 5, 9])[n]  # error okey
    e_h = trimf(efuzzy, [5, 9, 14])[n]  # error high
    if efuzzy[n] > 1:
        e_h = 1
    elif efuzzy[n] < 1:
        e_l = 1
    # --- Membership input error level: triangle --------
    de_n = trimf(efuzzy, [-1, -0.5, 0])[n]  # delta error negative
    de_z = trimf(efuzzy, [-0.5, 0, 0.5])[n]  # delta error zero
    de_p = trimf(efuzzy, [0, 0.5, 1])[n]  # delta error positive
    if defuzzy[n] > 0.5:
        de_p = 1
    elif defuzzy[n] < -0.5:
        de_n = 1
    # ---- Rule base --------------------------------------
    LTable_y = [[of, nc, cf],
                [of, nc, cf],
                [of, nc, cf]]
    # ---- perbandingan e, de untuk Center of Area
    perbandingan_e = [e_l, e_ok, e_h]
    perbandingan_de = [de_n, de_z, de_p]
    print("perbandingan_e: " + str(perbandingan_e) + " ; perbandingan_de: " + str(perbandingan_de))
    for i in range(3):
        for j in range(3):
            # print(i)
            perbandingan = min(perbandingan_e[i-1], perbandingan_de[j-1])
            miu = perbandingan * LTable_y[i-1][j-1]
            total_perbandingan = total_perbandingan + perbandingan
            total_miu = total_miu + miu
            print("perbandingan: " + str(perbandingan))
    outputvolt = total_miu / total_perbandingan
    print("outputvolt: " + str(outputvolt))
    sinyal_level= 0.586320532982868*outputvolt - 2.819872168774626  # volt sinyal kirim level, level ke volt
    bit_uPID = 4096*sinyal_level/10 # volt ke bit 4096
    if bit_uPID > 4096:
        bit_uPID = 4096
    if bit_uPID < 0:
        bit_uPID = 0

    e.append(e[n])
    de.append(e[n])

    # print(bit_uPID)
    sent = c.write_multiple_registers(16, [int(bit_uPID), 0])  # list bit pompa dan valve max.4096
    volt_pot = 69 # ntar hapus ya, ini ga kepake
    return volt_flow,input_level,volt_pot

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