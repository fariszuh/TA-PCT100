import tkinter as tk
from tkinter import ttk
import matplotlib.pyplot as plt
from matplotlib.backends.backend_tkagg import FigureCanvasTkAgg, NavigationToolbar2Tk
import csv
import math
n=0
timeLast = 0.0
PV_level_last = 0.0
Rtabung = 9 # dalam cm
arr_k = []
arr_n = []
arr_PV_level = []
arr_PV_flow = []
arr_PV_flow_sysId = []
arr_Q_lt = []
arr_PV_flow_ss = []
PV_flow_ss = 0
PV_flow_last = 0
Zss_flow_last = 0
PV_flow_min = 0
PV_flow_max = 0
dPV_flow_MaxMinlast = -0.1
# Ess_MinMax = 0 # error steady state saat puncak max dan lembah min

with open('Datasets/Datasets Open Loop Faris Ts 0.05.csv', 'r') as csvfile:
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
            # PV_flow = 0.4199798392422508 * PV_flow_v - 0.004550021909849653 # hasil regresi_FT.py
            PV_flow = PV_flow_v
            # ---- BUG PCT-100, ada delay pengukuran yg masuk ketika ngklik stop ----

            if k == 576:
                break
            arr_k.append(k)

            # ---- System Specification ----

            # Zss_flow_last = Zss_flow
            # Td = 0
            # Tuf =
            # Tu = Td + Tuf
            # Tn =
            # Zss = SP
            # y = a + b*t
            # b = 1/Tn
            # a = -Tu*b
            #
            # strejc_PV_flow = 1 - math.exp(-t*T)T
            # ---- Saving & Updating ----
            arr_n.append(n)
            arr_PV_level.append(PV_level)
            arr_PV_flow.append(PV_flow)
            # if k > 10:
            #     arr_PV_flow_sysId.append(PV_flow) # ambil data PV_flow setelah k=10 karena nilai minimum untuk avg Zss akan nyantol disitu
            # elif not PV_flow == PV_flow_last and k > 10
            #     PV_flow_max = max(arr_PV_flow_sysId)
            #     PV_flow_min = min(arr_PV_flow_sysId)
            #     Zss_flow = (PV_flow_min + PV_flow_max) / 2
            #     print("Zss min = " + str(PV_flow_min) + " ; Zss max = " + str(PV_flow_max) + " ; Zss avg = " + str(Zss_flow))
            #     PV_flow_last = PV_flow
            if not arr_PV_flow[n] == arr_PV_flow[n-1]:


                dPV_flow = PV_flow - PV_flow_last

                if dPV_flow > 0 and dPV_flow_MaxMinlast < 0: # Kurva flow naik
                    # titik minimum terakhir
                    PV_flow_min = PV_flow_last # capture titik maksimum
                    dPV_flow_MaxMinlast = dPV_flow
                elif dPV_flow < 0 and dPV_flow_MaxMinlast > 0: # Kurva flow turun
                    # titik maximum
                    PV_flow_max = PV_flow_last # capture titik minimum
                    dPV_flow_MaxMinlast = dPV_flow
                PV_flow_last = PV_flow
                PV_flow_ss = 0.5 * (PV_flow_max + PV_flow_min)
                # print("PV_flow = " + str(PV_flow) + " || dPV_flow = " + str(dPV_flow) + " ; dPV_flow_last = " + str(dPV_flow_MaxMinlast) + " ; flow min = " + str(PV_flow_min) + " ; flow max = " + str(PV_flow_max))
                # print("Yss = " + str(PV_flow_ss))
            arr_PV_flow_ss.append(PV_flow_ss)
            n = n + 1

def StepInfo():
    global PV_flow_ss
    print("---- Spesifikasi Respon Flow ----")
    print("Yss = " + str(PV_flow_ss))
    # ---- Spek 1: Delay Time (Td) -----
    # The delay time is the time required for the response to reach half the final value the very first time
    index_Td = [index for index in range(len(arr_PV_flow)) if arr_PV_flow[index] > 0.5*PV_flow_ss] # cari index dari PV flow yg > 50% PV_flow_ss
    Td = index_Td[0] + 1 # Discrete delay time ialah k dari total seluruh n yg berjalan (+1 karena k dimulai dari k=1 pada csv)
    PV_flow_Td = arr_PV_flow[Td-1] # Nilai Y saat delay time
    print("Td = " + str(Td) + "  ;   PV_flow(Td) = " + str(PV_flow_Td))

    # ---- Spek 2. Rise Time (Tr) ----
    # The rise time is the time required for the response to rise from 10%
    # to 90%, 5% to 95%, or 0% to 100% of its final value. For underdamped secondorder systems, the 0% to 100% rise time is normally used.
    index_Tr = [index for index in range(len(arr_PV_flow)) if arr_PV_flow[index] > PV_flow_ss]  # cari index dari PV flow yg > PV_flow_ss
    Tr = index_Tr[0] + 1
    PV_flow_Tr = arr_PV_flow[Tr-1]  # Nilai Y saat rise time
    print("Tr = " + str(Tr) + "  ;   PV_flow(Tr) = " + str(PV_flow_Tr))

    # ---- Spek 3. Peak Time ----
    # peak time is the time required for the response to reach the first peak of the overshoot
    PV_flow_Tp = max(arr_PV_flow)  # Nilai Ymax saat terjadi overshoot
    index_Tp = [index for index in range(len(arr_PV_flow)) if arr_PV_flow[index] == PV_flow_Tp]  # cari index dari PV flow yg > PV_flow_ss
    Tp = index_Tp[0] + 1
    # Mp: The maximum overshoot is the maximum peak value of the response curve measured from unity. If the final steady-state
    # value of the response differs from unity, then it is common to use the maximum percent overshoot.
    # Max Overshoot = [Y(tp)-Y(inf)]*100% / Y(inf)
    PV_flow_MaxOvershoot = (PV_flow_Tp - PV_flow_ss)*100 / PV_flow_ss
    print("Tp = " + str(Tp) + "  ;   PV_flow(Tp) = " + str(PV_flow_Tp)+ "  ;   Max Overshoot(%) = " + str(PV_flow_MaxOvershoot))

    # ---- Spek 4. Settling Time ----
    # Settling time is the time required for the response curve to
    # reach and stay within a range about the final value of size specified by absolute percentage of the final value (usually 2% or 5%).
    # The settling time is related to the largest time constant of the control system.
    PV_flow_st5 = PV_flow_ss * 5 / 100 # settling value 5% dari Yss (final value)
    PV_flow_st2 = PV_flow_ss * 2 / 100  # settling value 2% dari Yss (final value)
    PV_flow_st1 = PV_flow_ss * 1 / 100  # settling value 1% dari Yss (final value)
    Ess = arr_PV_flow - Yss
    index_Ts5 = [index for index in range(len(arr_PV_flow)) if arr_PV_flow[index] > PV_flow_ss]  # cari index dari PV flow yg > PV_flow_ss
    Tr = index_Tr[0] + 1
    PV_flow_Tr = arr_PV_flow[Tr - 1]  # Nilai Y saat rise time
    print("Tr = " + str(Tr) + "  ;   PV_flow(Tr) = " + str(PV_flow_Tr))

StepInfo()
window = tk.Tk()
window.title('GUI System Identification PCT-100')
window.configure(background = 'light blue')
window.geometry("1000x500")

# print("jumlah arr_k : " + str(len(arr_k)))
# print("jumlah arr_n : " + str(len(arr_n)))
# print("jumlah arr_PV_level : " + str(len(arr_PV_level)))
# print("jumlah arr_PV_flow : " + str(len(arr_PV_flow)))
# --------- FIGURE KIRI LEVEL ------------
fig = plt.Figure();
ax_level = fig.add_subplot(1,2,1)
ax_level.set_title('SysId Level Open Loop')
ax_level.set_xlabel('k ke-')
ax_level.set_ylabel('Level (cm)')
lines_level = ax_level.plot(arr_n,arr_PV_level,label="PV_Level") # garis level terhadap n, bukan k
# --------- FIGURE KANAN FLOW ------------
fig.subplots_adjust(wspace=0.3) # space antar figure kiri dan kanan
ax_flow = fig.add_subplot(1,2,2)
ax_flow.set_title('SysId Flow Open Loop')
ax_flow.set_xlabel('k ke-')
ax_flow.set_ylabel('Flow (lt/min)')
lines_flow = ax_flow.plot(arr_n,arr_PV_flow,label="PV_Flow") # garis flow
lines_flow_ss = ax_flow.plot(arr_n,arr_PV_flow_ss,label="PV_Flow_SS") # garis flow
ax_flow.legend(loc="lower right")

canvas = FigureCanvasTkAgg(fig, master=window)  # A tk.DrawingArea.
canvas.get_tk_widget().place(x = 10,y=10, width = 900,height = 400)

# toolbar = NavigationToolbar2Tk(canvas, window)
# toolbar.update()
# canvas.get_tk_widget().pack(side=tk.TOP, fill=tk.BOTH, expand=1)

# canvas.draw()
window.mainloop()