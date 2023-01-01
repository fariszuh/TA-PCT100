import time
import tkinter as tk
import matplotlib
from matplotlib.figure import Figure
from matplotlib.backends.backend_tkagg import FigureCanvasTkAgg

import matplotlib.pyplot as plt
matplotlib.use('TkAgg')
start = time.time()
arr_elapse = []
arr_volt_level = []
elapse_last = -1
fig = Figure();
ax = fig.add_subplot(111)

#ax = plt.axes(xlim=(0,100),ylim=(0, 120)); #displaying only 100 samples
ax.set_title('Serial Data');
ax.set_xlabel('Sample')
ax.set_ylabel('Voltage')
ax.set_xlim(0,100)
ax.set_ylim(-0.5,6)
lines = ax.plot([],[])[0]
window = tk.Tk()
window.title('GUI Open Loop PCT-100')
window.configure(background = 'light blue')
window.geometry("700x500")
canvas = FigureCanvasTkAgg(fig, master=window)  # A tk.DrawingArea.
canvas.get_tk_widget().place(x = 10,y=10, width = 500,height = 400)

while True:
    end = time.time()
    elapse = int(end - start)

    if not elapse == elapse_last:
        arr_elapse.append(elapse)
        volt_level = elapse + 1
        arr_volt_level.append(volt_level)
        lines.set_xdata(elapse)
        lines.set_ydata(volt_level)
        canvas.draw()
        canvas.flush_events()
        print(arr_elapse)
        elapse_last = elapse

