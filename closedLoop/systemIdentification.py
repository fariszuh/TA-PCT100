import tkinter as tk
from tkinter import ttk
import matplotlib.pyplot as plt
from matplotlib.backends.backend_tkagg import FigureCanvasTkAgg
import csv
n=0
timeLast = 0.0
PV_level_last = 0.0
Rtabung = 9 # dalam cm
arr_k = []
arr_n = []
arr_PV_level = []
arr_PV_flow = []
arr_Q_lt = []

with open('Datasets Open Loop Faris.csv', 'r') as csvfile:
    # print(type(arr_k))
    readCSV = csv.reader(csvfile)
    header = next(readCSV) # skip first line i.e. read header first and then iterate over each row od csv as a list

    if header != None: # Check file as empty
        for row in readCSV: # Iterate over each row after the header in the csv
            # row variable is a list that represents a row in csv
            k = int(row[0])
            timeNow = float(row[1])
            PV_level = float(row[2])
            PV_flow_v = float(row[3])
            PV_flow = 0.4199798392422508 * PV_flow_v - 0.004550021909849653 # hasil regresi_FT.py
            arr_k.append(k)

            if not PV_level == PV_level_last:
                # ---- Hitung Debit ----
                Atabung = 22 * Rtabung**2 / 7
                dPV_level = PV_level - PV_level_last # dH
                dt = timeNow - timeLast # dt

                Q_cm = Atabung * dPV_level / dt # dalam cm3/s
                Q_lt = Q_cm * 0.06 # dalam lt/min
                # print("Q = " + str(Q_lt) + " lt/min")

                arr_Q_lt.append(Q_lt)

                PV_level_last = PV_level
                timeLast = timeNow
            # print(PV_flow)
            if PV_flow
            # ---- Saving & Updating ----
            arr_n.append(n)
            arr_PV_level.append(PV_level)
            arr_PV_flow.append(PV_flow)

            n = n + 1

window = tk.Tk()
window.title('GUI System Identification PCT-100')
window.configure(background = 'light blue')
window.geometry("1000x500")

print("jumlah arr_k : " + str(len(arr_k)))
print("jumlah arr_n : " + str(len(arr_n)))
print("jumlah arr_PV_level : " + str(len(arr_PV_level)))
print("jumlah arr_PV_flow : " + str(len(arr_PV_flow)))
# --------- FIGURE KIRI LEVEL ------------
fig = plt.Figure();
ax_level = fig.add_subplot(1,2,1)
ax_level.set_title('SysId Level Open Loop')
ax_level.set_xlabel('k ke-')
ax_level.set_ylabel('Level (cm)')
lines_level = ax_level.plot(arr_n,arr_PV_level) # garis level terhadap n, bukan k
# --------- FIGURE KANAN FLOW ------------
fig.subplots_adjust(wspace=0.3) # space antar figure kiri dan kanan
ax_flow = fig.add_subplot(1,2,2)
ax_flow.set_title('SysId Flow Open Loop')
ax_flow.set_xlabel('k ke-')
ax_flow.set_ylabel('Flow (lt/min)')
lines_flow = ax_flow.plot(arr_n,arr_PV_flow) # garis flow

canvas = FigureCanvasTkAgg(fig, master=window)  # A tk.DrawingArea.
canvas.get_tk_widget().place(x = 10,y=10, width = 900,height = 400)
# canvas.draw()
window.mainloop()