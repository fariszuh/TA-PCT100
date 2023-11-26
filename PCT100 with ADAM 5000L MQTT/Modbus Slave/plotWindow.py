import matplotlib
import matplotlib.pyplot as plt
from matplotlib.figure import Figure
from matplotlib.backends.backend_tkagg import FigureCanvasTkAgg
import tkinter as tk

matplotlib.use('TkAgg') #bisa juga Qt5Agg dgn PyQt5
x = [1,2,3,4,5,6,7]
y = [2,3,4,5,6,7,8]
root = tk.Tk()
root.title('Real Time Plot')
root.configure(background = 'light blue')
root.geometry("700x500") # set the window size
#------create Plot object on GUI----------
# add figure canvas
fig = Figure();
ax = fig.add_subplot(111) # https://www.statology.org/fig-add-subplot/

#ax = plt.axes(xlim=(0,100),ylim=(0, 120)); #displaying only 100 samples
ax.set_title('Serial Data');
ax.set_xlabel('Sample')
ax.set_ylabel('Voltage')
ax.set_xlim(0,100)
ax.set_ylim(-0.5,6)
lines = ax.plot([],[])[0]

canvas = FigureCanvasTkAgg(fig, master=root)  # A tk.DrawingArea.
canvas.get_tk_widget().place(x = 10,y=10, width = 500,height = 400)
canvas.draw()

# fig = plt.figure()
# plt.plot(x,y,color='green')
# plt.title("Level response")
# plt.show()