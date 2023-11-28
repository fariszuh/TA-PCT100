# Tugas  Akhir PCT-100
Repository ini berisi file tugas akhir Implementasi PCT-100.
File yang tersedia berisi file program TA yang dibuat Penulis Muhammad Faris Zuhairi (2019 / Wisudawan 128 ITS), 
dengan judul berikut:

PERANCANGAN KONTROLER TERTANAM MENGGUNAKAN DIRECT NEURAL NETWORK UNTUK PENGATURAN LEVEL TANGKI PCT-100

Link Tugas Akhir: https://repository.its.ac.id/98936/ 
atau pada direktori "**Faris's Undergraduate Thesis (Buku TA)/07111940000164-Undergraduate_Thesis.pdf**"

Berikut foto prototype yang dibuat dan dihibahkan ke Lab. Kontrol dan Otomasi Dept. Teknik Elektro ITS

<img src="Work Documentation/Foto Prototype.jpg" height=150>
<img src="Work Documentation/Foto Prototype Baru.jpg" height=150>

## 1. Tahap Permodelan
Tahap ini model plant diambil menggunakan identifikasi plant dan penurunan rumus. 
Permodelan dimulai dengan mengambil data menggunakan STM32 dengan hasil datasets terdapat pada folder berikut:
+ **/Datasets for Modelling & Test Result/**
  - **/Karakteristik Drain Valve/** :
  Data yang digunakan untuk memodelkan drain valve.

    Divariasikan: tegangan drain (Vdrain) dan tegangan flow control valve (Vfc).
    Dijaga konstan: tegangan pompa (Vpompa) 10V.

  - **/Karakteristik Flow Control Valve/** :
  Data yang digunakan untuk memodelkan flow control valve.

    Divariasikan: tegangan pompa (Vpompa) dan tegangan flow control valve (Vfc).
    Dijaga konstan: tegangan drain (Vdrain) tertutup (0 VDC).

  - **/Karakteristik Pompa/** :
  Data yang digunakan untuk memodelkan pompa inlet.

    Divariasikan: tegangan pompa (Vpompa).
    Dijaga konstan: tegangan drain (Vdrain) tertutup (0 VDC) dan dan tegangan flow control valve (22 VDC).

  - **/Karakteristik AI USB4716/** :
    Hasil pengujian DAC Amplifier AO STM32 dengan AI USB4716.
    Pengambilan data ini tanpa menghubungkan prototype ke plant (actuator dan sensor).
    Kode pengujian ini ada di folder **/Pengujian (Testing)/**.
  
    Divariasikan: tegangan AO STM32.

  - **/Karakteristik AO USB4716/** :
    Hasil pengujian ADC AI STM32 dengan AO USB4716.
    Pengambilan data ini tanpa menghubungkan prototype ke plant (actuator dan sensor).
    Kode pengujian ini ada di folder **/Pengujian (Testing)/**.

    Divariasikan: tegangan AO USB4716.

  - **/Pengujian NN/Implementasi/** :
    Hasil pengujian algoritma NN yang ditanam pada STM32.
    Pengambilan data ini dengan menghubungkan prototype ke plant (actuator dan sensor).
  
    Divariasikan: learning rate konstan dan nilai alpha (adaptasi learning rate) --> sudah dipisahkan dalam 2 folder yang berbeda.

  - **/Rafif Firdiansyah's Level Sensor Data/** :
    Excel workbook pembacaan tegangan level sensor dan simpangannya dengan level aktual (cm).

  - **/With Both Drain Valve/** :
    Data yang digunakan untuk memodelkan kedua valve pada kondisi berikut:
    Terbuka: manual dan motor drain valve.
    Tertutup: tidak ada.

      Divariasi: tegangan drain (Vdrain).
    
      Dijaga konstan: tegangan pompa (10 Vpompa) dan tegangan flow control valve (15 Vfc).
  
  - **/with Manual Valve/** :
    Data yang digunakan untuk memodelkan manual valve pada kondisi berikut:
    Terbuka: manual drain valve.
    Tertutup: motor drain valve --> tegangan drain (0 Vdrain) .

      Divariasi: tegangan pompa (Vpompa), dan tegangan flow control valve (Vfc).
    
      Dijaga konstan: full open manual valve.

  - **/with Proportional Drain Valve/** :
    Data yang digunakan untuk memodelkan motor valve pada kondisi berikut:
    Terbuka: motor drain valve.
    Tertutup: manual drain valve.

      Divariasi: tegangan flow control valve (15 Vfc).
    
      Dijaga konstan: tegangan drain (Vdrain) dan tegangan pompa (Vpompa).

Sedangkan, folder berikut berisi file program DAQ untuk pengambilan data plant.

+ **/MATLAB USB-4716/** : pengambilan data melalui DAQ Advantech USB-4716
  - **/Code TA Dedy Motor Induksi & Altivar 610/** : 
  Kode dan Tugas Akhir Dedy / Bambang Permadi Widyasmara tentang Kontrol PID-GA Motor Induksi.
    - Call.m : file utama yang hanya di run untuk mulai mengambil dan mengirim data.
    - ReadWrite.m : file library yang dibuatkan Faris (tidak perlu diubah-ubah).
    
  - **/Code USB4716 TA Faris (Worked)/** :
  File yang sudah diuji dan berhasil membaca AI dan mengirim AO.
    - **/Hasil Pengujian ADC-DAC STM32 dengan USB4716/** :
    Berisi file .mat workspace MATLAB pembacaan pengujian sinyal ramp AI dan AO dari Kit STM32 Implementasi.
    - CascadeController.m : mencoba menyusun kontroler cascade berdasarkan AI-AO
    - InstantAI.m : library default MATLAB untuk analog input DAQ
    - NN.m : mencoba menyusun kontroler Direct NN
    - Static_AO.m : library default MATLAB untuk analog output DAQ
    - Static_AO_custom.m : perubahan Static_AO.m agar bisa mengirim sinyal berubah2 (tidak terbatas default sawtooth, sine, square, dll)
    - Static_AO_simple.m : simplifikasi dari Static_AO_custom.m
  - **/Library Example Bawaan Navigator App/** :
  Library MATLAB yang didapatkan dari tutorial aplikasi Navigator.exe.
  - **/Library python-advantech-DAQNavi-bdaqctrl/** : 
  Library python untuk USB-4716, masih perlu compiler dari C ke python

+ /regresi : regresi respon level dan flow untuk mendapat gain scaling transmitter
  - regresi_FT.m : mencari gain flow meter untuk mengubah tegangan volt ke debit liter/menit (lt/min)
  - regresi_LT.m : mencari gain level sensor untuk mengubah tegangan volt ke level (mm)
+ /write_csv : testing program python data logger
  - save_data_fopen.py : test buka data csv menggunakan fungsi fopen()
  - save_data_withopen.py : test buka data csv menggunakan fungsi withopen()

## 2. Tahap Simulasi
Model yang telah diperoleh pada tahap sebelumnya digunakan untuk desain kontroler. 

+ **/Modelling & PCT-100 Simulation Testing/** :
  - **/MAT simulasi/** : 
  Berisi file .mat workspace MATLAB. Setpoint/SP divariasikan 100mm dan dynamic naik turun.
  MOV divariasi bukaan mulai 0%, 50% (aka 0.5), 100% (aka 1), dan dynamic (uniform random).
  Untuk Learning Rate (lr) konstan, alpha=0 dan lrinit divariasi mulai dari 1e-5 hingga 5.
  Namun, untuk Adaptasi Learning Rate melalui parameter alpha, divariasikan alpha mulai 1e-4 hingga 0.1, dimana alpha identik dengan kecepatan perubahan learning rate (lr).
  
  - **/Proteus DAC PWM/** :
  Berisi simulasi proteus untuk rangkaian PWM generator, amplifier teganan AO, dan filter sebelum diimplementasikan bersama STM32.
  
  - **/Tank Level Modelling/** :
  Simulasi kontroler berdasarkan model. Namun file terbarunya berada diluar folder ini (upper directory sekali).
  - closedLoop.slx : Simulink closed loop system
  - loadDatasets.m : file function matlab untuk membuka datasets untuk permodelan/menampilkan grafik respon
  - modellingDatasets.m : pengolahan raw data plant untuk mendapatkan gain scaling model
  - openLoop.slx : Simulasi open loop system

+ **/Pengujian (Testing)/** : Berisi kode untuk pengujian performa kontroller.
  - pengujian_ADC_AI_STM.m : pengujian ADC AI STM32 dengan menginjeksi tegangan AO sinyal ramp naik turun pada USB4716.
  - pengujian_ADC_A0_STM.m : pengujian DAC A0 STM32 dengan DAC STM32 menginjeksi tegangan sinyal ramp naik turun ke USB4716.
  - pengujian_lr.m : berisi kode untuk plot hasil model NN satu satu dari datasets.

## 3. Tahap Implementasi

+ **/Datasheet and Manual Embedded System Kit/** :
  Berisi datasheet dan manual komponen prototype Embedded System Kit.
  - **/ADAM 5000L-TCP/** : 
  Folder berisi Advantech ADAM5000L TCP installer, modbus simulator, dan RD9700 USB-Ethernet Driver
  
  - **/Manual Advantech USB4716/** :
  Folder berisi datasheet Advantech USB4716 dan Tugas Akhir yang menggunakan perangkat DAQ ini.
  Installer DAQ ini dapat didownload terbaru pada laman resmi Advantech, aplikasi utility dan drivernya ialah Navigator.exe.

  - **/Manual PCT100 by Bytronic/** :
  Folder berisi datasheet PCT-100 dan Burkert Proportional Valve 2835D.

+ **/Embedded System Kit PCB & Acrylic Box/** :
Berisi file PCB dan 3D Akrilik.
  - **/3D Akrilik/** :
  Berisi file cetak akrilik dan gcode 3D print casing USB-TTL Converter. 
  - **/Schematic PCB/** :
  Berisi file PCB Eagle.

+ **/Faris's Undergraduate Thesis (Buku TA)/** :
Berisi dokumen Seminar Tugas Akhir (STA Himatektro ITS) dan Tugas Akhir Faris.

+ **/Konten Sidang (Thesis Defense) dan Proposal/** :
Berisi file proposal (dokumen dan PPT sidang sempro) dan PPT sidang TA.

+ **/Manual Book Embedded System Kit/** :
Berisi manual book dari prototype Embedded System Kit yang sudah dibuat.
Harap pengguna prototype dan asisten Lab. Kontrol dan Otomasi ITS mempelajari ini.

+ **/PCT100 with ADAM 5000L MQTT/** :
  Implementasi PCT100 untuk TA Khoiruz (PID-PSO) dan TA Rafif (fuzzy MQTT) menggunakan ADAM5000L/TCP.

  - **/Modelling & Testing/** : Pengujian kontroler fuzzy dan PID dituning PSO
    - **/Datasets/** : Hasil pengambilan data openloop untuk TA Khoiruz dan Rafif
    - **/multiple subscribe fuzzy/** : testing program MQTT subscribe untuk kontroler fuzzy
        * Close Loop Fuzzy Multiple Subscribe.py : subscribe untuk closed loop system
        * MQTTtestMultipleSubscribe.py : test data masuk MQTT
    - **/scaling_regresi_flow_meter/** : 
    mencari gain scaling flow, raw data dari software PCT100 (bukan DAQ) oleh Khoiruz untuk permodelan plant. 
    - closedLoop_fuzzy.py : kontroler closed loop fuzzy
    - closedLoop_fuzzy_azzam.py : kontroler close loop fuzzy dengan rule base TA Hamzah Nur Azzam Motor Induksi
    - closedLoop_level.py : kontroler PID close loop level khoiruz
    - closedLoop_level_buTri.py : kontroler PID khoiruz hasil revisi penguji Bu Trihastuti
    - openLoop_level_flow.py : open loop untuk mendapat respon level dan flow identifikasi
    - readStreamModbus.py : Reverse engineering informasi stream Modbus UDP dari DAQ ADAM4000L/TCP
    - systemIdentification.py : Identifikasi sistem orde 1 + time delay dan orde 2 sesuai jurnal Jacoubek_Pavel
    - testRampMotorDC_SPA.py : pengujian sinyal kontrol ramp motor DC untuk tugas sistem pengaturan adaptif
    - testTs.py : pengujian untuk memperkecil timesampling Ts Modbus UDP DAQ ADAM4000L
    - testUDPmasAdrian.py : ambil data informasi AI UDP
    - testUDPmodbus2.py : ambil data informasi AI UDP dengan algoritma lain
  - **/Python GUI/** : Test coba desain GUI Python Modbus TCP
  - **/Regresi Sensor/** : berisi regresi level transmitter (LT) dan flow meter (FT).
  - **/Serial STM32/Send Command.py** : berisi kode untuk send command SP, Kp, Ki, Kd ke mikrokontroller STM32 sebagai parameter kontroller.
  - **/List Pin IO ADAM.xlsx** : List pin Input Output ADAM5000L dan berisi address register Modbus TCP.

+ **/Rafif's MQTT Mobile App/** : Settingan MQTT Rafif untuk kontroler fuzzy.
  - **/Konfigurasi APP IoT MQTT Panel/** : Konfigurasi IoT MQTT Panel (Aplikasi PlayStore).
  - testMQTT.py : implementasi python dengan app IoT MQTT Panel (playstore)

+ **/Receipt & Buying Report/** : Kumpulan nota dan laporan keuangan pembuatan prototype Embedded System Kit.
  Budget Rp1juta dari Lab. via Pak Eka Iskandar.
  - Rekap Nota Embedded System Kit_Update 19 Nov 2023.xlsx : Laporan keuangan masuk keluar dan total.

+ **/References for Citation/** : Kumpulan buku dan jurnal penelitian.
  - **/Faris's Journal Reference/** : 
  Referensi jurnal faris untuk neural network dan plant mathematical modelling.
  - **/PID ANFIS Hakhi** : 
  Referensi jurnal Hakhi berkaitan dengan ANFIS.
  - **/Previous Thesis/** : 
  Tugas akhir sebelumnya yang membahas coupled tank, PCT single tank, quadruple tank, NN, dan TA lain yang berkaitan.
  - **/System Identification Journal/** :
  Jurnal referensi identifikasi model system.
  - **/Theory Book/** :
  Buku teori yang dapat digunakan untuk dasar teori bab 2.

+ **/STM32/MultichannelADC/** : Pengujian kontroler dengan program yang sudah tertanam

## Documentation
+ **/Work Documentation/** : 
  berisi dokumentasi pekerjaan dengan Sobat PCT 2023.
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
