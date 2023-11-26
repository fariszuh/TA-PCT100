# import the time module
import time
while True:
    # get the current time in seconds since the epoch
    seconds = time.time()
    # print("Seconds since epoch =", seconds)
    time.sleep(0.01)
    seconds2 = time.time()
    # print("Seconds since epoch =", seconds2)
    print("diff since epoch =", (seconds2-seconds))