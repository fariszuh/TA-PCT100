# python 3.6

import random
import time

from paho.mqtt import client as mqtt_client


broker = 'test.mosquitto.org'
port = 1883
topic = "PCT100/level"
SP = 10
kp = 0
ki = 0
kd = 0

def on_message_SP(client, userdata, message):
    global SP
    SP = str(message.payload.decode())
    # print(baca)
    # print(f"Received `{message.payload.decode()}` from `{message.topic}` topic")
def on_message_kp(client, userdata, message):
    global kp
    kp = str(message.payload.decode())
def on_message_ki(client, userdata, message):
    global ki
    ki = str(message.payload.decode())
def on_message_kd(client, userdata, message):
    global kd
    kd = str(message.payload.decode())

# def MQTT_subscribe(alamatTopik):
#     def on_message(client, userdata, message):
#         global baca
#         baca = str(message.payload.decode())
#         # print(f"Received `{message.payload.decode()}` from `{message.topic}` topic")
#
#
#     client.subscribe(alamatTopik)
#     client.on_message = on_message

    # def on_message(client, userdata, message):
    #     global hasilBaca
    #     hasilBaca = str(message.payload.decode("utf-8"))
    #     # print(hasilBaca)
    #     return hasilBaca
    #     # print("received message: " ,str(message.payload.decode("utf-8")))
    #     # return SP
    #
    # global hasilBaca
    # # print(alamatTopik)
    # client.subscribe(str(alamatTopik))
    # client.on_message = on_message
    # print(client)
    # return hasilBaca

def on_connect(client, userdata, flags, rc):
    if rc == 0:
        print("Connected to MQTT Broker!")
    else:
        print("Failed to connect, return code %d\n", rc)

    # client = mqtt_client.Client(client_id)


msg_count = 0
client = mqtt_client.Client()
# client.username_pw_set(username, password)
client.on_connect = on_connect
client.connect(broker, port)
client.loop_start()
SP = 0

while True:
    time.sleep(1)
    msg = f"messages: {msg_count}"
    result = client.publish(topic, msg)
    status = result[0]
    if status == 0:
        print(f"Send `{msg}` to topic `{topic}`")
    else:
        print(f"Failed to send message to topic {topic}")
    msg_count += 1

    # ['PCT100/SP', 'PCT100/kp', 'PCT100/ki', 'PCT100/kd']
    # [('PCT100/SP', 0), ('PCT100/kp', 0), ('PCT100/ki', 0), ('PCT100/kd', 0)]
    client.subscribe('PCT100/SP')
    client.on_message = on_message_SP
    client.unsubscribe('PCT100/SP')
    client.subscribe('PCT100/kp')
    client.on_message = on_message_kp
    client.unsubscribe('PCT100/kp')
    client.subscribe('PCT100/ki')
    client.on_message = on_message_ki
    client.unsubscribe('PCT100/ki')
    client.subscribe('PCT100/kd')
    client.on_message = on_message_kd
    client.unsubscribe('PCT100/kd')

    print("SP : " + str(SP) + " , kp : " + str(kp) + " , ki : " + str(ki) + " , kd : " + str(kd))
        # print(baca)

    # inMSG = MQTT_subscribe("PCT100/SP")
    # print("Masuk SP = " + str(inMSG))

    # bacaSP = on_message(client)
    # print("SP: " + str(bacaSP))


# time.sleep(30)
# client.loop_stop()

# if __name__ == '__main__':
#     run()
