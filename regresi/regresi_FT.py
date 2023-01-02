# input : flow sebenarnya
# output : flow yg dibaca transmitter
flow_sebenarnya = [0,0] #inisiasi flow
voltOutput_FT = [0,0] #inisiasi volt output
# data n=1, awal
flow_sebenarnya[0] = 0
voltOutput_FT[0] = 0
# data n terakhir
flow_sebenarnya[1] = 2.7
voltOutput_FT[1] = 10

# perhitungan pers. garis lurus
# m = (y2-y1) / (x2-x1)
m = (flow_sebenarnya[1] - flow_sebenarnya[0])/(voltOutput_FT[1] - voltOutput_FT[0])
# c = y1 - m*x1
c = flow_sebenarnya[0] - m*voltOutput_FT[0]
print(m)
print(c)

mi= 1/m
ci= -c/m

