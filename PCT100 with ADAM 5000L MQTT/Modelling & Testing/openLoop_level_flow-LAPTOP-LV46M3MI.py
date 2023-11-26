import tkinter as tk
import matplotlib.pyplot as plt
from matplotlib.backends.backend_tkagg import FigureCanvasTkAgg
import time
import csv
from pyModbusTCP.client import ModbusClient

c = ModbusClient(host="10.0.0.1", port=502, auto_open=True, auto_close=True)

# header = ['k','timestamp','PV_level (cm)','PV_flow (VDC)','dPVflow','dt','Q_FT (lt/min)']
header = ['k','timestamp','PV_level (cm)','PV_flow (VDC)']

f = open('Datasets/Datasets Open Loop Faris 10VDC baru Ts0.05.csv', 'w', encoding='UTF8', newline='') # open the file in the write mode
writer = csv.writer(f) # create the csv writer
writer.writerow(header) # write the header
timeSampling = 0.05 # dalam detik, min 0.05s
PV_flow_last = 0.0
timeQFT_last = 0.0
k = 0 # tidak boleh nol agar index tidak e[-1]
## --------INISIASI Variabel PID----------
volt_flow = 0
Rtabung = 9 # dalam cm
Atabung = 22*(Rtabung**2)/7
Rpipa = 0.4 # dalam cm
Apipa = 22*(Rpipa**2)/7
# ---- Outer loop: level control ----
SP = 10
e_level = [0.0, 0.0]
sum_e_level = [0.0, 0.0]
de_level = [0.0, 0.0]

kp_level = 68
ki_level = 2
kd_level = 10
# ---- Inner loop: flow control -----
e_flow = [0.0, 0.0]
sum_e_flow = [0.0, 0.0]
de_flow = [0.0, 0.0]

kp_flow = 20
ki_flow = 10
kd_flow = 6

uPID_level_last = 0
#---- PLOT DATA ----
def plot_data():
    global Ts, cond, k, arr_k, arr_PV_level, arr_PV_flow, timeLast, sent, PV_flow_last, timeQFT_last, elapsedTimeQFT, Q_FT
    if (cond==True):
        timeNow = time.time()
        # condition untuk sampling, jika sudah melebihi time sampling
        elapsedTime = timeNow - timeLast
        if elapsedTime >= timeSampling:
            Ts = elapsedTime # time sampling sebenarnya (beda antar k dan k-1)
            k = k + 1
            arr_k.append(k)
            PV_flow,PV_level = kontroller()
            # ------append into list to plot data--------
            arr_PV_level.append(PV_level)
            arr_PV_flow.append(PV_flow)

            timeLast = timeNow
            print("---- k = " + str(k) + "----")
            # ------PLOT FIGURE from list----------------
            ax_level.set_xlim(min(arr_k), max(arr_k))
            ax_level.set_ylim(min(arr_PV_level), max(arr_PV_level))
            lines_level.set_xdata(arr_k)
            lines_level.set_ydata(arr_PV_level)
            print("Level: " + str(PV_level) + " cm")

            ax_flow.set_xlim(min(arr_k), max(arr_k))
            ax_flow.set_ylim(min(arr_PV_flow), max(arr_PV_flow))
            lines_flow.set_xdata(arr_k)
            lines_flow.set_ydata(arr_PV_flow)
            print("Flow: " + str(PV_flow) + " Volt")

            timeRun = timeNow - start_time
            # if not PV_flow == PV_flow_last:
            #     Q_FT = 22 * 1 * 1 * dPVflow / (4 * 7 * elapsedTime)
            #     elapsedTimeQFT = timeNow - timeQFT_last
            #     timeQFT_last = timeNow
                # writer.writerow([k, timeRun, PV_level, PV_flow, dPVflow, elapsedTimeQFT, Q_FT])
            PV_flow_last = PV_flow
            # writer.writerow([k, timeRun, PV_level, PV_flow, dPVflow, elapsedTimeQFT, Q_FT])
            writer.writerow([k, timeRun, PV_level, PV_flow])
            canvas.draw()
        window.after(1, plot_data)

def plot_start():
    global cond, start_time
    cond = True
    start_time = time.time()
    print("Status: START ON")
    window.after(1, plot_data)

def plot_stop():
    global cond, sent
    cond = False
    print("Status: STOP (Drain ON)")
    sent = c.write_multiple_registers(16, [0, 4096])
    f.close()

def plot_off():
    global cond, sent
    cond = False
    print("Status: All OFF")
    sent = c.write_multiple_registers(16, [0, 0]) # biar MOV ga panas
    f.close()

def kontroller():
    global PV_flow, PV_level, k, sent, uPID_level_last
    regs = c.read_holding_registers(8, 8)  # format: (address,quantity). quantity gabole lebih, tapi boleh kurang
    PV_bit_flow = regs[0]
    PV_volt_flow = 20*PV_bit_flow/65535 - 10
    PV_flow = PV_volt_flow*0.4199798392422508 - 0.004550021909849653 # PV nanti ganti dengan hasil regresi

    PV_bit_level = regs[1]
    PV_volt_level = 20*PV_bit_level/65535 - 10 # dalam volt
    PV_level = 1.7055517310856645*PV_volt_level + 4.80943785889385 # dalam cm

    ## ---- KONTROLLER PID OUTER LOOP : LEVEL CONTROL -------
    e_level[k] = SP - PV_level # dalam cm
    sum_e_level[k] = sum_e_level[k] + e_level[k]*Ts # dalam cm.s
    de_level[k] = (e_level[k] - e_level[k-1])/Ts # dalam cm/s

    P_level = kp_level * e_level[k]
    I_level = ki_level * sum_e_level[k]
    D_level = kd_level * de_level[k]
    uPID_level = P_level + I_level + D_level # dalam cm, ini menjadi SP bagi inner loop flow
    SP_flow = uPID_level * 3.4373813408523457 / 20.022381544041103 # ----- Gain SP, Output Controller Outer Level, diubah ke flow -hasil konsul P.Hady dari Regresi_FT.py

    ## ---- KONTROLLER PID INNER LOOP : FLOW CONTROL -------
    e_flow[k] = SP_flow - PV_flow  # dalam cm
    sum_e_flow[k] = sum_e_flow[k] + e_flow[k] * Ts  # dalam cm.s
    de_flow[k] = (e_flow[k] - e_flow[k - 1]) / Ts  # dalam cm/s

    P_flow = kp_flow * e_flow[k]
    I_flow = ki_flow * sum_e_flow[k]
    D_flow = kd_flow * de_flow[k]
    uPID_flow = P_flow + I_flow + D_flow  # dalam cm, ini menjadi SP bagi inner loop flow


    MV_volt_level= 0.586320532982868*uPID_level - 2.819872168774626  # volt sinyal kirim level
    MV_bit_level = 4096*MV_volt_level/10 # bit sinyal kirim level ke pump
    if MV_bit_level > 4096:
        MV_bit_level = 4096
    if MV_bit_level < 0:
        MV_bit_level = 0

    uPID_level_last = uPID_level

    e_level.append(e_level[k])
    sum_e_level.append(e_level[k])
    de_level.append(e_level[k])

    e_flow.append(e_flow[k])
    sum_e_flow.append(e_flow[k])
    de_flow.append(e_flow[k])
    MV_bit_flow = 4096/2
    sent = c.write_multiple_registers(16, [int(MV_bit_flow), 0])  # list bit pompa dan valve max.4096
    # sent = c.write_multiple_registers(16, [4096, 0])  # OPEN LOOP Q_FT
    time.sleep(0.05)
    return PV_flow,PV_level

cond = False
timeLast = 0
arr_k = []
arr_PV_level = []
arr_PV_flow = []

window = tk.Tk()
window.title('GUI Open Loop PCT-100')
window.configure(background = 'light blue')
window.geometry("1000x500")
# --------- FIGURE KIRI LEVEL ------------
fig = plt.Figure();
ax_level = fig.add_subplot(1,2,1)
ax_level.set_title('Open Loop Level')
ax_level.set_xlabel('k ke-')
ax_level.set_ylabel('Level (cm)')
lines_level = ax_level.plot([],[])[0] # garis level
# --------- FIGURE KANAN FLOW ------------
fig.subplots_adjust(wspace=0.3) # space antar figure kiri dan kanan
ax_flow = fig.add_subplot(1,2,2)
ax_flow.set_title('Closed Loop Flow')
ax_flow.set_xlabel('k ke-')
ax_flow.set_ylabel('Flow (lt/min)')
lines_flow = ax_flow.plot([],[])[0] # garis flow

canvas = FigureCanvasTkAgg(fig, master=window)  # A tk.DrawingArea.
canvas.get_tk_widget().place(x = 10,y=10, width = 900,height = 400)
canvas.draw()
# ---------- BUTTON GUI ------------------
window.update();
start = tk.Button(window, text = "Start", font = ('calibri',12),command = lambda: plot_start())
start.place(x = 100, y = 450 )

window.update();
stop = tk.Button(window, text = "Stop", font = ('calibri',12), command = lambda:plot_stop())
stop.place(x = start.winfo_x()+start.winfo_reqwidth() + 20, y = 450)

window.update();
stop = tk.Button(window, text = "System OFF", font = ('calibri',12), command = lambda:plot_off())
stop.place(x = start.winfo_x()+start.winfo_reqwidth()+stop.winfo_x()+stop.winfo_reqwidth() + 20, y = 450)

window.mainloop()