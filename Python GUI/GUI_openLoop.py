import tkinter as tk
import matplotlib.pyplot as plt
from matplotlib.backends.backend_tkagg import FigureCanvasTkAgg
import time
import csv
header = ['time','voltage']
f = open('dataRafif.csv', 'w', encoding='UTF8', newline='') # open the file in the write mode
writer = csv.writer(f) # create the csv writer
writer.writerow(header) # write the header
timeSampling = 0.1 # dalam detik

#-----plot data-----
def plot_data():
    print("masuk plot data")
    global cond, arr_elapse, arr_volt_level, elapse_last
    if (cond==True):
        print(cond)
        end = time.time()
        elapse = int(end - start_time)
        #data=[]
        if not elapse == elapse_last:
            print("elapse = elapse last, sudah bisa masuk")
            arr_elapse.append(elapse)
            volt_level = kontroller(elapse)
            arr_volt_level.append(volt_level)

            elapse_last = elapse
            ax.set_xlim(0, max(arr_elapse))
            ax.set_ylim(-1, max(arr_volt_level))
            # lines = ax.plot(arr_elapse, arr_volt_level, color='green')
            lines.set_xdata(arr_elapse)
            lines.set_ydata(arr_volt_level)
            # write multiple rows
            writer.writerow([elapse, volt_level])
            print(arr_elapse)
            print(arr_volt_level)
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
    global cond
    cond = False
    print("sudah stop yaa")
    f.close()

def kontroller(elapse):
    volt_level = elapse + 0.5
    return volt_level

cond = False
elapse_last = -1
arr_elapse = []
arr_volt_level = []


window = tk.Tk()
window.title('GUI Open Loop PCT-100')
window.configure(background = 'light blue')
window.geometry("700x500")

fig = plt.Figure();
ax = fig.add_subplot(111)
ax.set_title('Open Loop Level')
ax.set_xlabel('Time (s)')
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
