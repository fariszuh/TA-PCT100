import matplotlib
from matplotlib.backends.backend_tkagg import FigureCanvasTkAgg
import tkinter as tk
import matplotlib.pyplot as plt
matplotlib.use('TkAgg')
root = tk.Tk()
fig, ax = plt.subplots()

canvas = FigureCanvasTkAgg(fig, root)
canvas.draw()
canvas.get_tk_widget().pack(fill=tk.BOTH, expand=True)

root.mainloop()