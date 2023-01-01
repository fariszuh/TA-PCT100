import tkinter as tk
import matplotlib.pyplot as plt
from matplotlib.backends.backend_tkagg import FigureCanvasTkAgg
import time
import csv

cond = False
elapse_last = -1
arr_elapse = []
arr_volt_level = []
start_time = time.time()
window = tk.Tk()
window.title('GUI Open Loop PCT-100')
window.configure(background = 'light blue')
window.geometry("700x500")

fig = plt.Figure();
ax = fig.add_subplot(111)
ax.set_title('Open Loop Level')
ax.set_xlabel('Time (s)')
ax.set_ylabel('Level (V)')

# lines = ax.plot([],[])
canvas = FigureCanvasTkAgg(fig, master=window)  # A tk.DrawingArea.
canvas.get_tk_widget().place(x = 10,y=10, width = 600,height = 400)
# canvas.draw()
# ----------create button---------
window.update();
start = tk.Button(window, text = "Start", font = ('calbiri',12),command = lambda: plot_start())
start.place(x = 100, y = 450 )

window.update();
stop = tk.Button(window, text = "Stop", font = ('calbiri',12), command = lambda:plot_stop())
stop.place(x = start.winfo_x()+start.winfo_reqwidth() + 20, y = 450)
# open the file in the write mode
f = open('dataRafif.csv', 'w', encoding='UTF8', newline='')
# create the csv writer
writer = csv.writer(f)
# write the header
header = ['time','vout']
writer.writerow(header)

def plot_start():
    global cond
    cond = True
    # s.reset_input_buffer()
    print("start mulai yaa")
    # return cond

def plot_stop():
    global cond
    cond = False
    print("sudah stop yaa")

while cond==True:
    print(cond)
    end = time.time()
    elapse = int(end - start_time)
    if not elapse == elapse_last:
        arr_elapse.append(elapse)
        volt_level = elapse + 0.5
        arr_volt_level.append(volt_level)
        data = ['elapse','volt_level']
        writer.writerow(data)

        elapse_last = elapse
        ax.set_xlim(0, max(arr_elapse))
        ax.set_ylim(-1, max(arr_volt_level))
        lines = ax.plot(arr_elapse,arr_volt_level,color='green')
        print(arr_elapse)
        print(arr_volt_level)
        canvas.draw()
        canvas.flush_events()
        window.update();
f.close()
window.mainloop()

# greeting = tk.Label(text="Hello, Tkinter")
# greeting.pack()
