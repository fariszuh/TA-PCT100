# TA-PCT100
Repository ini berisi file tugas akhir Implementasi PCT-100
File yang tersedia berisi file program TA yang dibuat Penulis Muhammad Faris Zuhairi (2019/Wisudawan 128), 
dengan judul berikut:
PERANCANGAN KONTROLER TERTANAM MENGGUNAKAN DIRECT NEURAL NETWORK UNTUK PENGATURAN LEVEL TANGKI PCT-100

## 1. Tahap Permodelan
Tahap ini model plant diambil menggunakan identifikasi plant dan penurunan rumus. 
+ /MATLAB USB-4716 : pengambilan data melalui DAQ Advantech USB-4716
  - CascadeController.m : mencoba menyusun kontroler cascade berdasarkan AI-AO
  - InstantAI.m : library default MATLAB untuk analog input DAQ
  - NN.m : mencoba menyusun kontroler Direct NN
  - Static_AO.m : library default MATLAB untuk analog output DAQ
  - Static_AO_custom.m : perubahan Static_AO.m agar bisa mengirim sinyal berubah2 (tidak terbatas default sawtooth, sine, square, dll)
  - Static_AO_simple.m : simplifikasi dari Static_AO_custom.m
+ /LabVIEW : (abaikan) hanya file backup belajar LabVIEW
+ /python-advantech-DAQNavi-bdaqctrl : Library python untuk USB-4716, masih perlu compiler dari C ke python
+ /regresi : regresi respon level dan flow untuk mendapat gain scaling transmitter
  - regresi_FT.m : mencari gain flow meter untuk mengubah tegangan volt ke debit liter/menit (lt/min)
  - regresi_LT.m : mencari gain level sensor untuk mengubah tegangan volt ke level (mm)
+ /write_csv : testing program python data logger
  - save_data_fopen.py : test buka data csv menggunakan fungsi fopen()
  - save_data_withopen.py : test buka data csv menggunakan fungsi withopen()
## 2. Tahap Simulasi
Model yang telah diperoleh pada tahap sebelumnya digunakan untuk desain kontroler. 
+ /MATLAB : Simulasi kontroler berdasarkan model
  - closedLoop.slx : Simulink closed loop system
  - loadDatasets.m : file function matlab untuk membuka datasets untuk permodelan/menampilkan grafik respon
  - modellingDatasets.m : pengolahan raw data plant untuk mendapatkan gain scaling model
  - openLoop.slx : Simulasi open loop system

## 3. Tahap Implementasi

+ /STM32/MultichannelADC : Pengujian kontroler dengan program yang sudah tertanam
+ /closedLoop : Pengujian kontroler fuzzy dan PID dituning PSO
  - /Datasets/ : Hasil pengambilan data openloop untuk TA Khoiruz dan Rafif
  - /multiple subscribe fuzzy/ : testing program MQTT subscribe untuk kontroler fuzzy
      * Close Loop Fuzzy Multiple Subscribe.py : subscribe untuk closed loop system
      * MQTTtestMultipleSubscribe : test data masuk MQTT
  - scaling_regresi_flow_meter : mencari gain scaling flow
      * Datasets csv Closed loop & Openloop : raw data PCT level
      * closedLoop_fuzzy.py : kontroler closed loop fuzzy
      * closedLoop_fuzzy_azzam.py : kontroler close loop fuzzy dengan rule base TA Hamzah Nur Azzam Motor Induksi
      * closedLoop_level.py : kontroler PID close loop level khoiruz
      * closedLoop_level_buTri.py : kontroler PID khoiruz hasil revisi penguji Bu Trihastuti
      * openLoop_level_flow.py : open loop untuk mendapat respon level dan flow identifikasi
      * readStreamModbus.py : Reverse engineering informasi stream Modbus UDP dari DAQ ADAM4000L/TCP
      * systemIdentification.py : Identifikasi sistem orde 1 + time delay dan orde 2 sesuai jurnal Jacoubek_Pavel
      * testRampMotorDC_SPA.py : pengujian sinyal kontrol ramp motor DC untuk tugas sistem pengaturan adaptif
      * testTs.py : pengujian untuk memperkecil timesampling Ts Modbus UDP DAQ ADAM4000L
      * testUDPmasAdrian.py : ambil data informasi AI UDP
      * testUDPmodbus2.py : ambil data informasi AI UDP dengan algoritma lain
 
+ /MQTT : Implementasi MQTT untuk kontroler fuzzy
  - testMQTT.py : implementasi python dengan app IoT MQTT Panel (playstore)

## Documentation
### Faris's NN Implementation Video (showed during Final Project Presentation/Sidang TA)
1. PCT100 with constant Set Point https://www.youtube.com/watch?v=iwgPA4LB7lY&ab_channel=MuhammadFarisZuhairi
2. PCT100 with Increasing-Decreasing Set Point (step 50mm) https://www.youtube.com/watch?v=AL7DxppEuDM&ab_channel=MuhammadFarisZuhairi

### Team's Documentation
1. [28/03/2023 - Part 1 Paparan Progress Bimbingan TA PCT-100 at 23:24:33] https://youtu.be/hUXw9mhMRqU
2. [28/03/2023 - Part 2 Paparan Progress Bimbingan TA PCT-100 at 23:34:30] https://youtube.com/shorts/yUkm82Lsc_I
3. [28/03/2023 - Part 3 Paparan Progress Bimbingan TA PCT-100 at 23:35:58] https://youtu.be/i6Gw3u0Zylg
4. [28/03/2023 - Part 4 Paparan Progress Bimbingan TA PCT-100 at 23:44:26] https://youtu.be/1I7eSQTP36s
5. [29/03/2023 - Part 5 Paparan Progress Bimbingan TA PCT-100 at 23:04:08] https://youtu.be/HnbYzEy3LrQ

### Disclaimer
Apabila terdapat kebingungan pada program/struktur repository, silahkan menghubungi author IDLINE: fariszuh
