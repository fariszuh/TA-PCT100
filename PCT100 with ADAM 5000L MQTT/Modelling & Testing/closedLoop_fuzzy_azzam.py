import tkinter as tk
import matplotlib.pyplot as plt
from matplotlib.backends.backend_tkagg import FigureCanvasTkAgg
import time
import csv
from pyModbusTCP.client import ModbusClient
import random
from skfuzzy import gaussmf, trimf
import numpy as np
from paho.mqtt import client as mqtt_client

broker = 'test.mosquitto.org'
port = 1883

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
# MQTT------------------
def on_message(client, userdata, message):
    global SP
    SP = str(message.payload.decode("utf-8"))
    # print("received message: " ,str(message.payload.decode("utf-8")))
    # return SP
    print("SP: " + str(SP))

def on_connect(client, userdata, flags, rc):
    if rc == 0:
        print("Connected to MQTT Broker!")
    else:
        print("Failed to connect, return code %d\n", rc)

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
    global cond, start_time, client
    cond = True
    start_time = time.time()
    # s.reset_input_buffer()
    print("start mulai yaa")
    # return cond
    client = mqtt_client.Client()
    # client.username_pw_set(username, password)
    client.on_connect = on_connect
    client.connect(broker, port)
    client.loop_start()
    SP = 0
    print("MQTT Siap")
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
    o_nl = -85  # output negative large [-100, -85, -70] dev=15
    o_nml = -75  # output negative medium large [-85, -72.5, -60] dev=12.5
    o_nm = -60 # output negative medium [ ]
    o_nms = -42.5  # output negative medium small
    o_ns = -20  # output negative small [-40, -20, 0] dev=20
    o_z = 0 # output zero
    o_ps = 20 # output positive small [0, 20, 40] dev=20
    o_pms = 42.5 # output positive medium small []
    o_pm = 60 # output positive medium
    o_pml = 75 # output positive medium large [60, 72.5, 85] dev=12.5
    o_pl = 87.5 # output positive large [70, 85, 100] dev=15
    # --- Membership input error level: triangle --------
    e_nl = trimf(efuzzy, [-55, -40, -25])[n]  # error negative low
    e_nm = trimf(efuzzy, [-40, -25, -10])[n]  # error negative medium
    e_ns = trimf(efuzzy, [-25, -12.5, 0])[n]  # error negative small
    e_z = trimf(efuzzy, [-10, 0, 10])[n] # error zero
    e_ps = trimf(efuzzy, [0, 12.5, 25])[n] # error positive small
    e_pm = trimf(efuzzy, [10, 25, 40])[n] # error positive medium
    e_pb = trimf(efuzzy, [25, 40, 55])[n] # error positive big
    if efuzzy[n] > 40:
        e_h = 1
    elif efuzzy[n] < -40:
        e_l = 1
    # --- Membership input error level: triangle --------
    de_nb = trimf(efuzzy, [-0.11, -0.08, -0.05])[n]  # delta error negative big
    de_nm = trimf(efuzzy, [-0.08, -0.05, -0.02])[n]  # delta error negative medium
    de_ns = trimf(efuzzy, [-0.05, -0.025, 0])[n]  # delta error negative small
    de_z = trimf(efuzzy, [-0.02, 0, 0.02])[n] # delta error zero
    de_ps = trimf(efuzzy, [0, 0.025, 0.05])[n] # delta error positive small
    de_pm = trimf(efuzzy, [0.02, 0.05, 0.08])[n] # delta error positive medium
    de_pb = trimf(efuzzy, [0.05, 0.08, 0.11])[n] # delta error positive big
    if defuzzy[n] > 0.08:
        de_p = 1
    elif defuzzy[n] < -0.08:
        de_n = 1
    # ---- Rule base --------------------------------------
    LTable_y = [[o_nl, o_nl, o_nml, o_nm, o_nms, o_ns, o_z],
                [o_nl, o_nml, o_nm, o_nms, o_ns, o_z, o_ps],
                [o_nml, o_nm, o_nms, o_ns, o_z, o_ps, o_pms],
                [o_nm, o_nms, o_ns, o_z, o_ps, o_pms, o_pm],
                [o_nms, o_ns, o_z, o_ps, o_pms, o_pm, o_pml],
                [o_ns, o_z, o_ps, o_pms, o_pm, o_pml, o_pl],
                [o_z, o_ps, o_pms, o_pm, o_pml, o_pl, o_pl]]
    # ---- perbandingan e, de untuk Center of Area
    perbandingan_e = [e_nl, e_nm, e_ns, e_z, e_ps, e_pm, e_pb]
    perbandingan_de = [de_nb, de_nm, de_ns, de_z, de_ps, de_pm, de_pb]
    print("perbandingan_e: " + str(perbandingan_e) + " ; perbandingan_de: " + str(perbandingan_de))
    for i in range(7):
        for j in range(7):
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
    # ----send to MQTT-----------------

    result = client.publish("PCT100/level", str(input_level))
    status = result[0]
    if status == 0:
        print(f"Send level berhasil")
    else:
        print(f"gagal send level")

    client.subscribe("PCT100/SP")
    client.on_message = on_message
    # print("SP: " + str(SP))

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