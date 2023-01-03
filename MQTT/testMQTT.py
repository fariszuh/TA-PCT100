# python 3.6

import random
import time

from paho.mqtt import client as mqtt_client

broker = 'test.mosquitto.org'
port = 1883
topic = "PCT100/level"
# generate client ID with pub prefix randomly
# client_id = f'python-mqtt-{random.randint(0, 1000)}'
# username = 'emqx'
# password = 'public'

# def connect_mqtt():
#     def on_connect(client, userdata, flags, rc):
#         if rc == 0:
#             print("Connected to MQTT Broker!")
#         else:
#             print("Failed to connect, return code %d\n", rc)
#
#     # client = mqtt_client.Client(client_id)
#     client = mqtt_client.Client(client_id)
#     # client.username_pw_set(username, password)
#     client.on_connect = on_connect
#     client.connect(broker, port)
#     return client

# def publish(client):
#     msg_count = 0
#     while True:
#         time.sleep(1)
#         msg = f"messages: {msg_count}"
#         result = client.publish(topic, msg)
#         # result: [0, 1]
#         status = result[0]
#         if status == 0:
#             print(f"Send `{msg}` to topic `{topic}`")
#         else:
#             print(f"Failed to send message to topic {topic}")
#         msg_count += 1

# def run():
#     client = connect_mqtt()
#     client.loop_start()
#     publish(client)
#     client.subscribe("TEMPERATURE")
#     client.on_message = on_message

def on_message(client, userdata, message):
    global SP
    SP = str(message.payload.decode("utf-8"))
    print("received message: " ,str(message.payload.decode("utf-8")))
    # return SP

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
    client.subscribe("PCT100/SP")
    client.on_message = on_message
    print("SP: " + str(type(SP)))


# time.sleep(30)
# client.loop_stop()

# if __name__ == '__main__':
#     run()
