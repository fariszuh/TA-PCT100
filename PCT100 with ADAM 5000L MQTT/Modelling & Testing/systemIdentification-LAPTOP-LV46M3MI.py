import tkinter as tk
from tkinter import ttk
import matplotlib.pyplot as plt
from matplotlib.backends.backend_tkagg import FigureCanvasTkAgg, NavigationToolbar2Tk
import csv
import numpy as np

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
arr_k_MaxMin = [] # k saat terjadi titik max min untuk perhitungan error steady state
arr_PV_flow_max = []
arr_k_Max = []
arr_PV_flow_min = []
arr_k_Min = []
arr_timeNow = []
# Ess_MinMax = 0 # error steady state saat puncak max dan lembah min
Ts5 = 69
Ts2 = 69
Ts1 = 69

PV_bit_flow = 4096  # SP write register saat ambil data csv sebelumnya (SP open loop)
PV_volt_flow = 10 * PV_bit_flow / 4096
SP = PV_volt_flow * 0.4199798392422508 - 0.004550021909849653  # dalam lt/min, unit step input level

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
            PV_flow = PV_flow_v*0.4199798392422508 - 0.004550021909849653

            # ---- BUG PCT-100, ada delay pengukuran yg masuk ketika ngklik stop ----

            if k == 576:
                break
            arr_k.append(k)
            arr_timeNow.append(timeNow)
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

            # if k==10:
            #     PV_flow_k10 = arr_PV_flow[k-1]
            #     print("PV flow [10]=" + str(PV_flow_k10))

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
                    arr_k_MaxMin.append(k-1)
                    arr_k_Min.append(k-1)
                    arr_PV_flow_min.append(PV_flow_min)

                elif dPV_flow < 0 and dPV_flow_MaxMinlast > 0: # Kurva flow turun
                    # titik maximum
                    PV_flow_max = PV_flow_last # capture titik minimum
                    dPV_flow_MaxMinlast = dPV_flow
                    arr_k_MaxMin.append(k-1)
                    arr_k_Max.append(k-1)
                    arr_PV_flow_max.append(PV_flow_max)

                PV_flow_last = PV_flow
                PV_flow_ss = 0.5 * (PV_flow_max + PV_flow_min)
                # print("PV_flow = " + str(PV_flow) + " || dPV_flow = " + str(dPV_flow) + " ; dPV_flow_last = " + str(dPV_flow_MaxMinlast) + " ; flow min = " + str(PV_flow_min) + " ; flow max = " + str(PV_flow_max))
                # print("Yss = " + str(PV_flow_ss))
            arr_PV_flow_ss.append(PV_flow_ss)
            n = n + 1

def StepInfo():
    global PV_flow_ss, Ts5, Ts2, Ts1
    print("---- Spesifikasi Respon Flow ----")
    print("Yss = " + str(PV_flow_ss) + " | Yss5% l = " + str(0.95*PV_flow_ss) + " | Yss5% u = " + str(1.05*PV_flow_ss) + " | Yss2% l = " + str(0.98*PV_flow_ss) + " | Yss2% u = " + str(1.02*PV_flow_ss) + " | Yss1% l = " + str(0.99*PV_flow_ss) + " | Yss1% u = " + str(1.01*PV_flow_ss))
    # ---- Spek 1: Delay Time (Td) -----
    # The delay time is the time required for the response to reach half the final value the very first time
    index_Td = [index for index in range(len(arr_PV_flow)) if arr_PV_flow[index] > 0.5*PV_flow_ss] # cari index dari PV flow yg > 50% PV_flow_ss
    k_Td = index_Td[0] # Discrete delay time ialah k dari total seluruh n yg berjalan (+1 karena k dimulai dari k=1 pada csv), # + 1 karena array python dimulai dari 0, sedangkan k discrete dimulai dari 1
    Td = arr_timeNow[k_Td]
    PV_flow_Td = arr_PV_flow[k_Td] # Nilai Y saat delay time
    print("Td = " + str(Td) + "  ;   PV_flow(Td) = " + str(PV_flow_Td))

    # ---- Spek 2. Rise Time (Tr) ----
    # The rise time is the time required for the response to rise from 10%
    # to 90%, 5% to 95%, or 0% to 100% of its final value. For underdamped secondorder systems, the 0% to 100% rise time is normally used.
    index_Tr = [index for index in range(len(arr_PV_flow)) if arr_PV_flow[index] > PV_flow_ss]  # cari index dari PV flow yg > PV_flow_ss
    k_Tr = index_Tr[0] # + 1 karena array python dimulai dari 0, sedangkan k discrete dimulai dari 1
    Tr = arr_timeNow[k_Tr]
    PV_flow_Tr = arr_PV_flow[k_Tr]  # Nilai Y saat rise time
    print("Tr = " + str(Tr) + "  ;   PV_flow(Tr) = " + str(PV_flow_Tr))

    # ---- Spek 3. Peak Time ----
    # peak time is the time required for the response to reach the first peak of the overshoot
    PV_flow_Tp = max(arr_PV_flow)  # Nilai Ymax saat terjadi overshoot
    index_Tp = [index for index in range(len(arr_PV_flow)) if arr_PV_flow[index] == PV_flow_Tp]  # cari index dari PV flow yg > PV_flow_ss
    k_Tp = index_Tp[0] # + 1 karena array python dimulai dari 0, sedangkan k discrete dimulai dari 1
    Tp = arr_timeNow[k_Tp]
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
    # print("E st 5% = " + str(PV_flow_st5))
    # print("E st 2% = " + str(PV_flow_st2))
    # print("E st 1% = " + str(PV_flow_st1))
    # print("arr k max = " + str(arr_k_Max))
    # print("arr PV flow max" + str(arr_PV_flow_max))
    # print("arr k min = " + str(arr_k_Min))
    # print("arr PV flow min" + str(arr_PV_flow_min))
    #
    # print("len arr k max" + str(len(arr_k_Max)))
    # print("len arr k min" + str(len(arr_k_Min)))
    # print("len arr PV max" + str(len(arr_PV_flow_max)))
    # print("len arr PV min" + str(len(arr_PV_flow_min)))
    # cek jika size vektornya sama
    #
    # Ess = arr_PV_flow[arr_k_Max[0]] - arr_PV_flow[arr_k_Min[0]]
    # Ess = arr_PV_flow[arr_k_Max[1]] - arr_PV_flow[arr_k_Min[0]]
    #
    # Ess = arr_PV_flow[arr_k_Max[1]] - arr_PV_flow[arr_k_Min[1]]
    # Ess = arr_PV_flow[arr_k_Max[2]] - arr_PV_flow[arr_k_Min[1]]
    #
    # Penamaan variabel:
    # arr_k_Max: array berisi k saat maximum
    # arr_k_Min: array berisi k saat minimum
    # index_k_Min:

    if len(arr_k_Max) == len(arr_k_Min):
        # index_MaxMin berisi urutan letak titik maximum dan minimum steady state
        Ts1 = None
        Ts2 = None
        Ts5 = None
        for n_Max in range(len(arr_k_Max)):
            # nilai PV diambil dari index k yg maximum dan minimum, dimana indexnya merupakan urutan dari index MaxMin
            k_Max = arr_k_Max[n_Max]
            Ymax = arr_PV_flow[k_Max]

            k_Min = arr_k_Min[n_Max]
            Ymin= arr_PV_flow[k_Min]

            Ess = Ymax - Ymin

            Yss = PV_flow_ss
            bool_st1_min = (0.99*Yss <= Ymin <= 1.01*Yss)
            bool_st1_max = (0.99*Yss <= Ymax <= 1.01*Yss)
            bool_st2_min = (0.98 * Yss <= Ymin < 0.99 * Yss) or (1.01 * Yss < Ymin <= 1.02 * Yss)
            bool_st2_max = (0.98 * Yss <= Ymax < 0.99 * Yss) or (1.01 * Yss < Ymax <= 1.02 * Yss)
            bool_st5_min = (0.95*Yss <= Ymin < 0.98*Yss) or (1.02*Yss < Ymin <= 1.05*Yss)
            bool_st5_max = (0.95*Yss <= Ymax < 0.98*Yss) or (1.02*Yss < Ymax <= 1.05*Yss)
            # Dari kode dibawah coba dibalik antara if bool st max dan elif bool min (dibolak balik supaya barangkali ada Ts yg lebih kecil)
            # misal if bool_st_min jadi if bool_st_max, begitupun untuk elif harus ikut pula dibalik
            # Ts + 1 karena array python dimulai dari 0, sedangkan array k discrete dimulai dari 1
            if Ts1 == None:
                if bool_st1_min:
                    Ts1 = arr_timeNow[k_Min]
                elif bool_st1_max:
                    Ts1 = arr_timeNow[k_Max]
            if Ts2 == None:
                if bool_st2_min:
                    Ts2 = arr_timeNow[k_Min]
                elif bool_st2_max:
                    Ts2 = arr_timeNow[k_Max]
            if Ts5 == None:
                if bool_st5_min:
                    Ts5 = arr_timeNow[k_Min]
                elif bool_st5_max:
                    Ts5 = arr_timeNow[k_Max]

            # print("Y(t) = " + str(Y) + " ; Ts1% = " + str(Ts1)+ " ; Ts2% = " + str(Ts2)+ " ; Ts5% = " + str(Ts5))
    else:
        print("(  Beda len(arr_k_Min) dan len(arr_k_Min)  )")
    print("Ess = " + str(Ess) + " ; Ts1% = " + str(Ts1) + " ; Ts2% = " + str(Ts2) + " ; Ts5% = " + str(Ts5))
    # index_Ts5 = [index for index in range(len(arr_PV_flow)) if arr_PV_flow[index] > PV_flow_ss]  # cari index dari PV flow yg > PV_flow_ss

    # Metode Vitechkova
    index_Tvtechkov = [index for index in range(len(arr_PV_flow)) if
                arr_PV_flow[index] > PV_flow_ss]  # cari index dari PV flow yg > PV_flow_ss
    k33 = int(0.33*index_Tvtechkov[0])
    k70 = int(0.70*index_Tvtechkov[0])
    y33 = arr_PV_flow[k33]  # Nilai 33% final value
    y70 = arr_PV_flow[k70]  # Nilai 70% final value
    t33 = arr_timeNow[k33]
    t70 = arr_timeNow[k70]

    # FIRST ORDER VITECHKOVA
    # Gv1 = Kv1/(Tv1*s + 1) * e^(-Tdv1*s)
    Tdv1 = 1.498*t33 - 0.498*t70 # + 1 karena array python dimulai dari 0, sedangkan k discrete dimulai dari 1
    Tv1 = 1.245*(t70 - t33) # + 1 karena array python dimulai dari 0, sedangkan k discrete dimulai dari 1
    # Didapat dari hasil regresi_FT.py

    Kv1 = PV_flow_ss/SP
    print("Kv1 = " + str(Kv1) + " ; Tdv1 = " + str(Tdv1) + " ; Tv1 = " + str(Tv1) + " ; k33% = " + str(k33) + " ; y33% = " + str(y33) + " ; k70% = " + str(k70) + " ; y70% = " + str(y70))

    # SECOND ORDER VITECHKOVA
    # Gv2 = Kv2/(Tv2*s + 1)**2 * e^(-Tdv2*s)
    Tdv2 = 1.937*t33 - 0.937*t70 # + 1 karena array python dimulai dari 0, sedangkan k discrete dimulai dari 1
    Tv2 = 0.794*(t70 - t33) # + 1 karena array python dimulai dari 0, sedangkan k discrete dimulai dari 1
    Kv2 = Kv1
    print("Kv2 = " + str(Kv2) + " ; Tdv2 = " + str(Tdv2) + " ; Tv2 = " + str(Tv2))

    # LATZEL
    # GL = K/(tauL*s + 1)**n
    k10 = int(0.1*index_Tvtechkov[0])
    k50 = int(0.5*index_Tvtechkov[0])
    k90 = int(0.9*index_Tvtechkov[0])
    t10 = arr_timeNow[k10]
    t50 = arr_timeNow[k50]
    t90 = arr_timeNow[k90]
    # print(k10)
    miu = t10/t90 # + 1 karena array python dimulai dari 0, sedangkan k discrete dimulai dari 1
    # melalui metode latzel, dengan miu mendekati 0.137, dipilih orde n=2
    alpha10 = 1.88
    alpha50 = 0.596
    alpha90 = 0.257
    tauL = alpha10*t10 + alpha50*t50 + alpha90*t90 # + 1 karena array python dimulai dari 0, sedangkan k discrete dimulai dari 1
    Klatzel = PV_flow_ss/SP
    print("Klatzel = " + str(Klatzel) + " ; n=2 ; tauL = " + str(tauL) + " ; miu = " + str(miu))

    # HARRIOT 2ND ORDER -> TIDAK BISA DIMODELKAN
    # GH = K/(tauH1*s + 1)*(tauH2*s + 1) * e**(-TdH*s)
    k73 = int(0.73 * index_Tvtechkov[0])
    t73 = arr_timeNow[k73]
    t1 = t73 / (2*1.3)
    index_t1 = [index for index in range(len(arr_PV_flow)) if arr_timeNow[index] > t1] # cari index k1
    k_t1 = index_t1[0]
    PV_flow_t1 = arr_PV_flow[k_t1]

    # HARRIOT CURVE yharriot -> y1/yinf , xharriot -> tauH1 / (tauH1 + tauH2)
    y_Harriot = PV_flow_t1/PV_flow_ss # nanti digunakan untuk menentukan x_harriot pada smith curve
    TdH = 1.937 * t33 - 0.937 * t70
    print("t73 = " + str(t73) + " ; yHarriot = " + str(y_Harriot) + " ; t1 = " + str(t1) + " ; y(t1) = " + str(PV_flow_t1) + " ; TdH = " + str(TdH))
    # y bernilai < 0.26, diluar smith curve, metode harriot tidak bisa digunakan, x_harriot tdk bisa ditentukan shg tauH1, tauH2 tidak ada
    # If the fractional response is less than 0,26 or greater than 0,39 at this point, the method is not
    # applicable, which generally indicates that the process requires a model that is higher than
    # second order or that is underdamped (Jakoubek)
    # tauH1 = t73*x / 1.3
    # tauH2 = t73*(1-x) / 1.3

    # SMITH METHOD (Jakoubek, Dale Process Textbook p111)
    # G_sm = K/(tau^2 * s^2 + 2*tau*zeta*s + 1) --> K/(a*s^2 + b*s + 1)
    k20 = int(0.2 * index_Tvtechkov[0])
    t20 = arr_timeNow[k20]
    k60 = int(0.6 * index_Tvtechkov[0])
    t60 = arr_timeNow[k60]
    x_smith = t20/t60
    y_smith_zeta = 4 # estimasi nilai zeta
    y_smith_t60divtau = 10 # estimasi nilai t60/tau
    tau_smith = t60/y_smith_t60divtau
    denum_a = tau_smith**2 # koefisien denum untuk s^2
    denum_b = 2*tau_smith*y_smith_zeta # koefisien denum untuk s
    K_smith = PV_flow_ss/SP
    print("Ksmith = " + str(K_smith) + " ; denum_a = " + str(denum_a) + " ; denum_b = " + str(denum_b) +" ; tau = " + str(tau_smith) + " ; zeta = " + str(y_smith_zeta) + " ; x_smith = " + str(x_smith))

    # Sundaresan & Krishnaswamy Method
    # G_SK = K/(tauSK*s + 1) * e^-(TdSK*s)
    k353 = int(0.353 * index_Tvtechkov[0])
    t353 = arr_timeNow[k353]
    k853 = int(0.853 * index_Tvtechkov[0])
    t853 = arr_timeNow[k853]
    TdSK = 1.3*t353 - 0.29*t853
    tauSK = 0.67*(t853 - t353)
    K_krisnaswamy = PV_flow_ss/SP
    print("K_krisnaswamy = " + str(K_krisnaswamy) + " ; tauSK = " + str(tauSK) + " ; TdSK = " + str(TdSK))

    # STREJC METHOD (Mikles & Fikar)
    # Strejc untuk tau<0
    k72 = int(0.72 * index_Tvtechkov[0])
    k2_strejc = int(0.3574 * k72/1.2564) # t73 sudah dicari di baris kode metode harriott
    t2_strejc = arr_timeNow[k2_strejc]
    # t2_strejc = 0.3574 * t73/1.2564 # cara lain menentukan t2 strejc, langsung tanpa lewat k2 arr_timeNow
    Y_strejc = arr_PV_flow[k2_strejc]
    print("k2_strejc t<0 = " + str(k2_strejc) + " ; t2_strejc = " + str(t2_strejc) + " ; Y(k2_strejc) = " + str(Y_strejc))

    # Strejc untuk tau>=0
    # G_ST2 = K/(tau_strejc*s + 1)^n
    Ku = 4
    Tu = arr_timeNow[Ku]
    Tn = Tp # Tp diperoleh dari arr_timeNow di k_Tp
    rasio_TuTn = Tu / Tn  # tau
    n = 2 # Dipilin n=2 karena tau=0.104 pada tabel
    # diumpamakan inflexion point terletak antara Tu dan Tn
    k_inflexion = int(0.5*(Ku + k_Tp))
    t_inflexion = arr_timeNow[k_inflexion]
    y_inflexion = arr_PV_flow[k_inflexion]
    tau_strejc = t_inflexion/(n - 1)
    print("tau_strejc = " + str(tau_strejc) + " ; rasio tau = Tu/Tn = " + str(rasio_TuTn) + " ; t_inflexion = " + str(t_inflexion) + " ; y_inflexion = " + str(y_inflexion))
    # # PERHITUNGAN TABEL STREJC (tidak digunakan)
    # sum_kn = 0
    # n_strejc = 2 # orde n TF strejc
    # for k in range(n_strejc):
    #     sum_kn = sum_kn + (n_strejc - 1) ** k / np.math.factorial(k)
    # fn = np.exp(-1 * (n_strejc - 1)) * ((n_strejc - 1) ** n_strejc / np.math.factorial(n_strejc - 1) + sum_kn) - 1
    # gn = ((n_strejc - 1)**(n_strejc - 1))*np.exp(-(n_strejc - 1))/np.math.factorial(n_strejc - 1)
    # # print("n_strejc = " + str(n_strejc) + " ; f(n) = " + str(fn) + " ; g(n) = " + str(gn))

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