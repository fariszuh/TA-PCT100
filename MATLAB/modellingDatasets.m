%% READ DATASETS
clc; clear; close all

[k_2V,timestamp_2V,MV_volt_FCValve_2V,MV_volt_pompa_2V,volt_flow_2V,volt_level_2V] = loadDatasets(2,22);
[k_4V,timestamp_4V,MV_volt_FCValve_4V,MV_volt_pompa_4V,volt_flow_4V,volt_level_4V] = loadDatasets(4,22);
[k_6V,timestamp_6V,MV_volt_FCValve_6V,MV_volt_pompa_6V,volt_flow_6V,volt_level_6V] = loadDatasets(6,22);
[k_8V,timestamp_8V,MV_volt_FCValve_8V,MV_volt_pompa_8V,volt_flow_8V,volt_level_8V] = loadDatasets(8,22);
[k_10V,timestamp_10V,MV_volt_FCValve_10V,MV_volt_pompa_10V,volt_flow_10V,volt_level_10V] = loadDatasets(10,22);

% figure, title("Flow Meter vs Input Pompa");
figure, subplot(2,1,1), title("Flow Meter vs Input Pompa");
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
% plot(k_2V,ones(length(k_2V),1)*SI_2V_ss,"DisplayName","V_{pompaSS}=2V");

SI_4V = stepinfo(volt_flow_4V(klevelStartNaik_4V:indexSplitMax));
SI_4V_ss = mean([SI_4V.SettlingMin,SI_4V.SettlingMax])
% plot(k_4V,ones(length(k_4V),1)*SI_4V_ss,"DisplayName","V_{pompaSS}=4V");

SI_6V = stepinfo(volt_flow_6V(klevelStartNaik_6V:indexSplitMax));
SI_6V_ss = mean([SI_6V.SettlingMin,SI_6V.SettlingMax])
% plot(k_6V,ones(length(k_6V),1)*SI_6V_ss,"DisplayName","V_{pompaSS}=6V");

SI_8V = stepinfo(volt_flow_8V(klevelStartNaik_8V:indexSplitMax));
SI_8V_ss = mean([SI_8V.SettlingMin,SI_8V.SettlingMax])
% plot(k_8V,ones(length(k_8V),1)*SI_8V_ss,"DisplayName","V_{pompaSS}=8V");

SI_10V = stepinfo(volt_flow_10V(klevelStartNaik_10V:indexSplitMax));
SI_10V_ss = mean([SI_10V.SettlingMin,SI_10V.SettlingMax])
% plot(k_10V,ones(length(k_10V),1)*SI_10V_ss,"DisplayName","V_{pompaSS}=10V");

plot(k_2V(1:2100),volt_flow_2V(1:2100),"DisplayName","V_{pompa}=2V");
plot(k_4V(1:2100),volt_flow_4V(1:2100),"DisplayName","V_{pompa}=4V");
plot(k_6V(1:2100),volt_flow_6V(1:2100),"DisplayName","V_{pompa}=6V");
plot(k_8V(1:2100),volt_flow_8V(1:2100),"DisplayName","V_{pompa}=8V");
plot(k_10V(1:2100),volt_flow_10V(1:2100),"DisplayName","V_{pompa}=10V");
hold off
% legend;

subplot(2,1,2), title("Level Transmitter vs Input Pompa");
xlabel('k');
ylabel('V_{LT} (volt)');
hold on
plot(k_2V(1:2100),volt_level_2V(1:2100),"DisplayName","V_{pompa}=2V");
plot(k_4V(1:2100),volt_level_4V(1:2100),"DisplayName","V_{pompa}=4V");
plot(k_6V(1:2100),volt_level_6V(1:2100),"DisplayName","V_{pompa}=6V");
plot(k_8V(1:2100),volt_level_8V(1:2100),"DisplayName","V_{pompa}=8V");
plot(k_10V(1:2100),volt_level_10V(1:2100),"DisplayName","V_{pompa}=10V");
hold off
legend;
clear folderDatasets folderKarakteristik;

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

global indexSplitMax;

dhdt_2V = dHdT(timestamp_2V,volt_level_2V,klevelStartNaik_2V)
dhdt_4V = dHdT(timestamp_4V,volt_level_4V,klevelStartNaik_4V)
dhdt_6V = dHdT(timestamp_6V,volt_level_6V,klevelStartNaik_6V)
dhdt_8V = dHdT(timestamp_8V,volt_level_8V,klevelStartNaik_8V)
dhdt_10V = dHdT(timestamp_10V,volt_level_10V,klevelStartNaik_10V)

arr_dhdt = [dhdt_2V, dhdt_4V, dhdt_6V, dhdt_8V, dhdt_10V];
arr_volt_flow = [SI_2V_ss, SI_4V_ss, SI_6V_ss, SI_8V_ss, SI_10V_ss];3

figure, title("V_{FT} vs dh/dt");
hold on
xlabel("dh/dt (mm/s)");
ylabel("V_{LT} (Volt)");
scatter(arr_dhdt, arr_volt_flow,"DisplayName","Sampel");
% hitung persamaan garis lurus untuk konversi mm level ke tegangan V_FT
m_FT = (arr_volt_flow(5) - arr_volt_flow(1))/(arr_dhdt(5) - arr_dhdt(1));
c_FT = arr_volt_flow(5) - m_FT*arr_dhdt(5);
disp("V_FT(h) = "+ m_FT + " * h " + c_FT);

avg_volt_flow_regresi = m_FT*arr_dhdt + c_FT*ones(1,length(arr_dhdt));
x = [0 arr_dhdt];
y = m_FT*[0 arr_dhdt] + c_FT*ones(1,length(x));
plot(x,y,"DisplayName","Estimasi Regresi");
hold off

% % save to .mat untuk econometricModeler, mencari model ARX
% T_dhdt = [k_4V(1:length(dhdt_4V)), volt_level_4V(1:length(dhdt_4V)), volt_flow_4V(1:length(dhdt_4V)), dhdt_4V];
% save("sysId_Faris_4V.mat","T_dhdt");

%% DERIVATIVE dh/dt
function dhdt = dHdT(timestamp, volt_level, klevelStartNaik)
    global indexSplitMax;
    dh = volt_level(indexSplitMax) - volt_level(klevelStartNaik);
    dt = timestamp(indexSplitMax) - timestamp(klevelStartNaik);    
    dhdt = dh/dt;
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