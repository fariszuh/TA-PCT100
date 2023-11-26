# input : flow sebenarnya
# output : flow yg dibaca transmitter
flow_sebenarnya = [0,0] #inisiasi flow
voltOutput_FT = [0,0] #inisiasi volt output
level_cm = [0,0]
t = [0,0]
Rtabung = 9 # dalam cm
Atabung = 22 * Rtabung**2 / 7

# data n=1, awal
t[0] = 0.0009741783142089844
level_cm[0] = 0
flow_sebenarnya[0] = 0
voltOutput_FT[0] = 0.010833905546654421
# data n terakhir
t[1] = 88.9720675945282
level_cm[1] = 20.022381544041103
flow_sebenarnya[1] = Atabung*(level_cm[1] - level_cm[0])/(t[1] - t[0])*0.06 #dalam lt/min
print("flow sebenarnya [1] = " + str(flow_sebenarnya[1]))
voltOutput_FT[1] = 8.19546807049668

# perhitungan pers. garis lurus
# m = (y2-y1) / (x2-x1)
m = (flow_sebenarnya[1] - flow_sebenarnya[0])/(voltOutput_FT[1] - voltOutput_FT[0])
# c = y1 - m*x1
c = flow_sebenarnya[0] - m*voltOutput_FT[0]
print("Q = " + str(flow_sebenarnya[1]))
print("m = " + str(m))
print("c = " + str(c))
print("Q(t) = " + str(m) + " * VFT(t) + " + str(c))

mi= 1/m
ci= -c/m

