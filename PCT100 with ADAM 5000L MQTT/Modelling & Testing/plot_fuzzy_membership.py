import numpy as np
import skfuzzy as fuzz
import matplotlib.pyplot as plt

x = np.arange(11)
mfx = fuzz.trimf(x, [0, 5, 10])

plt.plot(x, mfx)
plt.show()

# Online Python compiler (interpreter) to run Python online.
# Write Python 3 code in this online editor and run it.
print("Hello world")