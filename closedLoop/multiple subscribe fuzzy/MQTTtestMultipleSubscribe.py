# python 3.6

import time
from paho.mqtt import client as mqtt_client

def on_message(client, userdata, message):
    global stringParameterMasuk
    stringParameterMasuk = str(message.payload.decode())
    # rekam(rrr)
def on_connect(client, userdata, flags, rc):
    if rc == 0:
        print("Connected to MQTT Broker!")
    else:
        print("Failed to connect, return code %d\n", rc)
def on_disconnect(client, userdata, rc):
    print("Client Got Disconnected")

broker = 'test.mosquitto.org'
port = 1883
topic = "PCT100/level"
SP = 10
kp = 0
ki = 0
kd = 0

msg_count = 0

client = mqtt_client.Client()
# client.username_pw_set(username, password)
print("Connecting to MQTT Broker ....")
client.on_connect = on_connect
client.connect(broker, port)
client.loop_start()

stringParameterMasuk = "# Belum dapat string subscribe"

while True:
    time.sleep(1)
    msg = f"messages: {msg_count}"
    result = client.publish(topic, msg)
    status = result[0]
    # if status == 0:
    #     print(f"Send `{msg}` to topic `{topic}`")
    # else:
    #     print(f"Failed to send message to topic {topic}")
    msg_count += 1

    client.subscribe([('PCT100/SP', 1), ('PCT100/kp', 1), ('PCT100/ki', 1), ('PCT100/kd', 1)])
    client.on_message = on_message
    # print(stringParameterMasuk)
    words = stringParameterMasuk.split('=')

    if words[0]=='SP':
        SP=float(words[1])
    elif words[0]=='kp':
        kp=float(words[1])
    elif words[0] == 'ki':
        ki = float(words[1])
    elif words[0] == 'kd':
        kd = float(words[1])
    else:
        print("StringParameter Undefined")
    print("SP = " + str(SP) + " ; kp = " + str(kp) + " ; ki = " + str(ki) + " ; kd = " + str(kd))
    # print(words)