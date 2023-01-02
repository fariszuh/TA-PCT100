# input : level sebenarnya
# output : level yg dibaca transmitter
level_sebenarnya = [0,0] #inisiasi level
voltOutput_LT = [0,0] #inisiasi volt output
# data n=1, awal
level_sebenarnya[0] = 4.5
voltOutput_LT[0] = -0.1814297703517198
# data n terakhir
level_sebenarnya[1] = 20
voltOutput_LT[1] = 8.906538490882735

# perhitungan pers. garis lurus
# m = (y2-y1) / (x2-x1)
m = (level_sebenarnya[1] - level_sebenarnya[0])/(voltOutput_LT[1] - voltOutput_LT[0])
# c = y1 - m*x1
c = level_sebenarnya[0] - m*voltOutput_LT[0]
mi= 1/m
ci= -c/m
print(mi)
print(ci)
