%% READ DATASETS
clc; clear; close all

[k_2V,timestamp_2V,MV_volt_FCValve_2V,MV_volt_pompa_2V,volt_flow_2V,volt_level_2V] = loadDatasets(2,22);
[k_4V,timestamp_4V,MV_volt_FCValve_4V,MV_volt_pompa_4V,volt_flow_4V,volt_level_4V] = loadDatasets(4,22);
[k_6V,timestamp_6V,MV_volt_FCValve_6V,MV_volt_pompa_6V,volt_flow_6V,volt_level_6V] = loadDatasets(6,22);
[k_8V,timestamp_8V,MV_volt_FCValve_8V,MV_volt_pompa_8V,volt_flow_8V,volt_level_8V] = loadDatasets(8,22);
[k_10V,timestamp_10V,MV_volt_FCValve_10V,MV_volt_pompa_10V,volt_flow_10V,volt_level_10V] = loadDatasets(10,22);

figure, title("Flow Meter vs Input Pompa");
xlabel('k');
ylabel('V_{FT} (volt)');

% potong array untuk mendapat nilai steady state
indexSplitMin = 200;
indexSplitMax = 2100;

klevelStartNaik_2V = 1145;
klevelStartNaik_4V = 711;
klevelStartNaik_6V = 544;
klevelStartNaik_8V = 441;
klevelStartNaik_10V = 408;

hold on
SI_2V = stepinfo(volt_flow_2V(klevelStartNaik_2V:indexSplitMax));
SI_2V_ss = mean([SI_2V.SettlingMin,SI_2V.SettlingMax])
plot(k_2V,ones(length(k_2V),1)*SI_2V_ss,"DisplayName","V_{pompaSS}=2V");
SI_4V = stepinfo(volt_flow_4V(klevelStartNaik_4V:indexSplitMax));
SI_4V_ss = mean([SI_4V.SettlingMin,SI_4V.SettlingMax])
plot(k_4V,ones(length(k_4V),1)*SI_4V_ss,"DisplayName","V_{pompaSS}=4V");
SI_6V = stepinfo(volt_flow_6V(klevelStartNaik_6V:indexSplitMax));
SI_6V_ss = mean([SI_6V.SettlingMin,SI_6V.SettlingMax])
plot(k_6V,ones(length(k_6V),1)*SI_6V_ss,"DisplayName","V_{pompaSS}=6V");
SI_8V = stepinfo(volt_flow_8V(klevelStartNaik_8V:indexSplitMax));
SI_8V_ss = mean([SI_8V.SettlingMin,SI_8V.SettlingMax])
plot(k_8V,ones(length(k_8V),1)*SI_8V_ss,"DisplayName","V_{pompaSS}=8V");
SI_10V = stepinfo(volt_flow_10V(klevelStartNaik_10V:indexSplitMax));
SI_10V_ss = mean([SI_10V.SettlingMin,SI_10V.SettlingMax])
plot(k_10V,ones(length(k_10V),1)*SI_10V_ss,"DisplayName","V_{pompaSS}=10V");

plot(k_2V,volt_flow_2V,"DisplayName","V_{pompa}=2V");
plot(k_4V,volt_flow_4V,"DisplayName","V_{pompa}=4V");
plot(k_6V,volt_flow_6V,"DisplayName","V_{pompa}=6V");
plot(k_8V,volt_flow_8V,"DisplayName","V_{pompa}=8V");
plot(k_10V,volt_flow_10V,"DisplayName","V_{pompa}=10V");
hold off
legend;

figure, title("Level Transmitter vs Input Pompa");
xlabel('k');
ylabel('V_{LT} (volt)');
hold on
plot(k_2V,volt_level_2V,"DisplayName","V_{pompa}=2V");
plot(k_4V,volt_level_4V,"DisplayName","V_{pompa}=4V");
plot(k_6V,volt_level_6V,"DisplayName","V_{pompa}=6V");
plot(k_8V,volt_level_8V,"DisplayName","V_{pompa}=8V");
plot(k_10V,volt_level_10V,"DisplayName","V_{pompa}=10V");
hold off
% legend;
clear folderDatasets folderKarakteristik;

dh = volt_level_2V(indexSplitMax) - volt_level_2V(klevelStartNaik_2V);
dt = timestamp_2V(indexSplitMax) - timestamp_2V(klevelStartNaik_2V);

%% MENCARI GAIN SENSOR: LEVEL TRANSMITTER
mm_level = [80.8, 128.4, 171.5, 208.15, 224]; % mm diambil scr visual
mm_level = mm_level; 
G_LT = []; % gain level transmitter
avg_volt_level = [];
banyakDataTerakhir = 1;

lastData_volt_level_2V = volt_level_2V(length(volt_level_2V)-banyakDataTerakhir : length(volt_level_2V))';
avg_volt_level = [avg_volt_level, mean(lastData_volt_level_2V)];

lastData_volt_level_4V = volt_level_4V(length(volt_level_4V)-banyakDataTerakhir : length(volt_level_4V))';
avg_volt_level = [avg_volt_level, mean(lastData_volt_level_4V)];

lastData_volt_level_6V = volt_level_6V(length(volt_level_6V)-banyakDataTerakhir : length(volt_level_6V))';
avg_volt_level = [avg_volt_level, mean(lastData_volt_level_6V)];

lastData_volt_level_8V = volt_level_8V(length(volt_level_8V)-banyakDataTerakhir : length(volt_level_8V))';
avg_volt_level = [avg_volt_level, mean(lastData_volt_level_8V)];

lastData_volt_level_10V = volt_level_10V(length(volt_level_10V)-banyakDataTerakhir : length(volt_level_10V))';
avg_volt_level = [avg_volt_level, mean(lastData_volt_level_10V)];

% menghilangkan sample terakhir (saat 224mm) karena floating ball sudah
% menyentuh dinding atas. Level air terus naik, tapi V_LT stuck 10V di
% batas maximumnya.
mm_level = mm_level(1:4);
avg_volt_level = avg_volt_level(1:4);

figure
title("Level Tangki vs Output Level Transmitter");
xlabel('Level Air (mm)');
ylabel('V_{LT} (volt)');
hold on
scatter(mm_level,avg_volt_level,"DisplayName","Sampel");
% hitung persamaan garis lurus untuk konversi mm level ke tegangan V_LT
m_LT = (avg_volt_level(4) - avg_volt_level(1))/(mm_level(4)-mm_level(1));
c_LT = avg_volt_level(4) - m_LT*mm_level(4);
disp("V_LT(h) = "+ m_LT + " * h " + c_LT);

avg_volt_level_regresi = m_LT*mm_level + c_LT*ones(1,length(mm_level));
plot(mm_level,avg_volt_level_regresi,"DisplayName","V_{LT}(h) Estimasi");
hold off
legend

%% MENCARI GAIN SENSOR: FLOW METER

global numAvg dh arr_dh arr_dh_avg;
numAvg = 4; % jumlah data yg akan dirata2 untuk mendapat dh
[arr_dh_2V,arr_dt_2V] = dHdT(timestamp_2V(klevelStartNaik_2V:length(k_2V)),volt_level_2V(klevelStartNaik_2V:length(k_2V)));
[arr_dh_4V,arr_dt_4V] = dHdT(timestamp_4V(klevelStartNaik_4V:length(k_4V)),volt_level_4V(klevelStartNaik_4V:length(k_4V)));
[arr_dh_6V,arr_dt_6V] = dHdT(timestamp_6V(klevelStartNaik_6V:length(k_6V)),volt_level_6V(klevelStartNaik_6V:length(k_6V)));
[arr_dh_8V,arr_dt_8V] = dHdT(timestamp_8V(klevelStartNaik_8V:length(k_8V)),volt_level_8V(klevelStartNaik_8V:length(k_8V)));
[arr_dh_10V,arr_dt_10V] = dHdT(timestamp_10V(klevelStartNaik_10V:length(k_10V)),volt_level_10V(klevelStartNaik_10V:length(k_10V)));

% % save to .mat untuk econometricModeler, mencari model ARX
% T_dhdt = [k_4V(1:length(dhdt_4V)), volt_level_4V(1:length(dhdt_4V)), volt_flow_4V(1:length(dhdt_4V)), dhdt_4V];
% save("sysId_Faris_4V.mat","T_dhdt");

%% SYSTEM IDENTIFICATION FLOW
format compact
% ARMAX identification, input: dh/dt, output: V_FT
% A(z)y(t) = B(z)u(t) + C(z)e(t)
na = 1; % 0 jika bentuknya hanya y(t) = x(t) + beta
nb = 1;
nc = 0;
nk = 0;

% ambil pembacaan setelah floating ball mulai naik
volt_flow_2V_ballStart = volt_flow_2V(klevelStartNaik_2V+numAvg:length(volt_flow_2V));
volt_flow_4V_ballStart = volt_flow_4V(klevelStartNaik_4V+numAvg:length(volt_flow_4V));
volt_flow_6V_ballStart = volt_flow_6V(klevelStartNaik_6V+numAvg:length(volt_flow_6V));
volt_flow_6V_ballStart_train = volt_flow_6V_ballStart(1:1000);
volt_flow_6V_ballStart_test = volt_flow_6V_ballStart(1001:1798);
volt_flow_8V_ballStart = volt_flow_8V(klevelStartNaik_8V+numAvg:length(volt_flow_8V));
volt_flow_10V_ballStart = volt_flow_10V(klevelStartNaik_10V+numAvg:length(volt_flow_10V));

volt_level_2V_ballStart = volt_level_2V(klevelStartNaik_2V+numAvg:length(volt_level_2V));
volt_level_4V_ballStart = volt_level_4V(klevelStartNaik_4V+numAvg:length(volt_level_4V));
volt_level_6V_ballStart = volt_level_6V(klevelStartNaik_6V+numAvg:length(volt_level_6V));
% volt_level_6V_ballStart_train = volt_level_6V_ballStart(1:1000);
% volt_level_6V_ballStart_test = volt_level_6V_ballStart(1001:1798);
volt_level_8V_ballStart = volt_level_8V(klevelStartNaik_8V+numAvg:length(volt_level_8V));
volt_level_10V_ballStart = volt_level_10V(klevelStartNaik_10V+numAvg:length(volt_level_10V));

% buat pasangan input output discrete: data = iddata(y,u,Ts)
tt_2V = iddata(volt_flow_2V_ballStart.*arr_dt_2V,arr_dh_2V,50);
sys_2V = armax(tt_2V,[na nb nc nk]);
sys_2V;
tt_4V = iddata(volt_flow_4V_ballStart.*arr_dt_4V,arr_dh_4V,50);
sys_4V = armax(tt_4V,[na nb nc nk]);
sys_4V;
tt_6V = iddata(volt_flow_6V_ballStart.*arr_dt_6V,arr_dh_6V,50);
sys_6V = armax(tt_6V,[na nb nc nk]);
sys_6V;
tt_8V = iddata(volt_flow_8V_ballStart.*arr_dt_8V,arr_dh_8V,50);
sys_8V = armax(tt_8V,[na nb nc nk]);
sys_8V;
tt_10V = iddata(volt_flow_10V_ballStart.*arr_dt_10V,arr_dh_10V,50);
sys_10V = armax(tt_10V,[na nb nc nk]);
sys_10V;

%% PLOT RESPON
figure; hold on;
title("dh Vs k");
xlabel('k');
ylabel('dh (mm)');
plot(k_4V(klevelStartNaik_4V+numAvg:length(volt_flow_4V)), arr_dh_4V)
legend
hold off

figure; hold on;
title("Vft Vs k");
xlabel('k');
ylabel('V_{FT} (volt)');
plot(k_4V(klevelStartNaik_4V+numAvg:length(volt_flow_4V)),volt_flow_4V(klevelStartNaik_4V+numAvg:length(timestamp_4V)))
%% DERIVATIVE dh/dt
function [arr_dh, arr_dt] = dHdT(timestamp, volt_level)
    global numAvg dh arr_dh arr_dh_avg;
    arr_dh = [];
    arr_dh_avg = zeros(numAvg,1); % array berisi [Vlt(i-3),Vlt(i-2),Vlt(i-1),Vlt(i) dan terus updating dgn shifting ke kiri untuk tambah nilai baru
    arr_dh_avg_prev = zeros(numAvg,1); % array_dh_avg pada iterasi sebelumnya untuk menghitung selisih mean sekarang
    arr_dt = [];
    
    for i = 1:length(volt_level)
        if i <= numAvg
            % untuk pertama looping, i=1 di skip karena menyebabkan pemanggilan
            % i=0 yaitu array dgn index nol. matlab indexing mulai dari 1.
            continue; 
        else
            % perhitungan turunan dh/dt
            arr_dh_avg = [arr_dh_avg(2:numAvg); volt_level(i)];
            
            dh = mean(arr_dh_avg) - mean(arr_dh_avg_prev);
            dt = timestamp(i) - timestamp(i-numAvg);
            arr_dh = [arr_dh; dh];
            arr_dh_avg_prev = arr_dh_avg;
            arr_dt = [arr_dt; dt];
            
        end
    end
end

%% LOAD DATASETS
function [k,timestamp,MV_volt_FCValve,MV_volt_pompa,volt_flow,volt_level] = loadDatasets(Vpompa,Vfc)
    folderDatasets = "D:\OneDrive - Institut Teknologi Sepuluh Nopember\Tugas Akhir\TA PCT100\Datasets\";
    folderKarakteristik = "Karakteristik Pompa\";
    src = folderDatasets + folderKarakteristik + Vpompa + "Vpompa_" + Vfc + "Vfc.txt";
    T = readmatrix(src);
    k = T(:,1);  
    timestamp = T(:,2);
    % revisi, sambung hitungan karena datasets terbatas max 65535 uint16_t
    for t=1:length(timestamp)
        if t == 1
            continue; % skipped in first loop
        else
            diff = timestamp(t) - timestamp(t-1);
            % jika diff (selisih) timestamp dengan sebelumnya negatif, maka
            % harus ditambah dengan lastValue (nilai bit overflow)
            if diff < 0
                if Vpompa == 2
                    lastValue = 65521;
                elseif Vpompa == 4
                    lastValue = 65533;
                elseif Vpompa == 6
                    lastValue = 65526;
                elseif Vpompa == 8
                    lastValue = 65494;
                elseif Vpompa == 10
                    lastValue = 65506;
                end
            else
                lastValue = 0;
            end
            timestamp(t) = timestamp(t) + lastValue;
        end
    end
    
    MV_volt_FCValve = T(:,3);
    MV_volt_pompa = T(:,4);
    bit_flow = T(:,5);
    bit_level = T(:,6);

    % scaling langsung dikali 10V bukan 3.3V, karena sudah dlm bentuk bit
    volt_flow = bit_flow * 10 / 4096; 
    volt_level = bit_level * 10 / 4096;
end