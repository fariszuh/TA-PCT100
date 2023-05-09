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

plot(k_2V(1:2100),volt_flow_2V(1:indexSplitMax),"DisplayName","V_{pompa}=2V");
plot(k_4V(1:2100),volt_flow_4V(1:indexSplitMax),"DisplayName","V_{pompa}=4V");
plot(k_6V(1:2100),volt_flow_6V(1:indexSplitMax),"DisplayName","V_{pompa}=6V");
plot(k_8V(1:2100),volt_flow_8V(1:indexSplitMax),"DisplayName","V_{pompa}=8V");
plot(k_10V(1:2100),volt_flow_10V(1:indexSplitMax),"DisplayName","V_{pompa}=10V");
hold off
% legend;

subplot(2,1,2), title("Level Transmitter vs Input Pompa");
xlabel('k');
ylabel('V_{LT} (volt)');
hold on
plot(k_2V(1:2100),volt_level_2V(1:indexSplitMax),"DisplayName","V_{pompa}=2V");
plot(k_4V(1:2100),volt_level_4V(1:indexSplitMax),"DisplayName","V_{pompa}=4V");
plot(k_6V(1:2100),volt_level_6V(1:indexSplitMax),"DisplayName","V_{pompa}=6V");
plot(k_8V(1:2100),volt_level_8V(1:indexSplitMax),"DisplayName","V_{pompa}=8V");
plot(k_10V(1:2100),volt_level_10V(1:indexSplitMax),"DisplayName","V_{pompa}=10V");
hold off
legend;
clear folderDatasets folderKarakteristik;

%% MENCARI GAIN SENSOR: LEVEL TRANSMITTER
mm_level = [80.8, 128.4, 171.5, 208.15, 224]; % mm diambil scr visual
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

mm_level_est_2V = (volt_level_2V + c_LT)/m_LT;
mm_level_est_4V = (volt_level_4V + c_LT)/m_LT;
mm_level_est_6V = (volt_level_6V + c_LT)/m_LT;
mm_level_est_8V = (volt_level_8V + c_LT)/m_LT;
mm_level_est_10V = (volt_level_10V + c_LT)/m_LT;

dhdt_2V = dHdT(timestamp_2V,mm_level_est_2V,klevelStartNaik_2V)
dhdt_4V = dHdT(timestamp_4V,mm_level_est_4V,klevelStartNaik_4V)
dhdt_6V = dHdT(timestamp_6V,mm_level_est_6V,klevelStartNaik_6V)
dhdt_8V = dHdT(timestamp_8V,mm_level_est_8V,klevelStartNaik_8V)
dhdt_10V = dHdT(timestamp_10V,mm_level_est_10V,klevelStartNaik_10V)

arr_dhdt = [dhdt_2V, dhdt_4V, dhdt_6V, dhdt_8V, dhdt_10V];
arr_volt_flow_ss = [SI_2V_ss, SI_4V_ss, SI_6V_ss, SI_8V_ss, SI_10V_ss];

figure, title("V_{FT} vs dh/dt");
hold on
xlabel("dh/dt (mm/s)");
ylabel("V_{FT} (Volt)");
scatter(arr_dhdt, arr_volt_flow_ss,"DisplayName","Sampel");
% hitung persamaan garis lurus untuk konversi mm level ke tegangan V_FT
m_FT = (arr_volt_flow_ss(5) - arr_volt_flow_ss(1))/(arr_dhdt(5) - arr_dhdt(1));
c_FT = arr_volt_flow_ss(1) - m_FT*arr_dhdt(1);
disp("V_FT(h) = "+ m_FT + " * h " + c_FT);

x_flow_est = [0 arr_dhdt];
y_flow_est = m_FT*[0 arr_dhdt] + c_FT*ones(1,length(x_flow_est));
plot(x_flow_est,y_flow_est,"DisplayName","Estimasi Regresi");
legend
hold off
% penguatan gain flow 
r_tabung = 90; % dalam mm
A_tabung = pi*(r_tabung^2);
G_FT = A_tabung/m_FT;
% 6 x 10^-2 ialah konversi factor mm3/ms ke lt/min
Qin_2V = G_FT*volt_flow_2V(1:indexSplitMax)*6*(10^-2);
Qin_4V = G_FT*volt_flow_4V(1:indexSplitMax)*6*(10^-2);
Qin_6V = G_FT*volt_flow_6V(1:indexSplitMax)*6*(10^-2);
Qin_8V = G_FT*volt_flow_8V(1:indexSplitMax)*6*(10^-2);
Qin_10V = G_FT*volt_flow_10V(1:indexSplitMax)*6*(10^-2);

figure, title("Flow dalam lt/min");
hold on
xlabel("k");
ylabel("Flow (lt/min)");
plot(k_2V(1:indexSplitMax),Qin_2V,"DisplayName","Flow V_{pompa}=2V");
plot(k_4V(1:indexSplitMax),Qin_4V,"DisplayName","Flow V_{pompa}=4V");
plot(k_6V(1:indexSplitMax),Qin_6V,"DisplayName","Flow V_{pompa}=6V");
plot(k_8V(1:indexSplitMax),Qin_8V,"DisplayName","Flow V_{pompa}=8V");
plot(k_10V(1:indexSplitMax),Qin_10V,"DisplayName","Flow V_{pompa}=10V");
hold off
legend

% % save to .mat untuk econometricModeler, mencari model ARX
% T_dhdt = [k_4V(1:length(dhdt_4V)), volt_level_4V(1:length(dhdt_4V)), volt_flow_4V(1:length(dhdt_4V)), dhdt_4V];
% save("sysId_Faris_4V.mat","T_dhdt");

%% DERIVATIVE dh/dt
function dhdt = dHdT(timestamp, mm_level_est, klevelStartNaik)
    global indexSplitMax;
    dh = mm_level_est(indexSplitMax) - mm_level_est(klevelStartNaik);
    dt = timestamp(indexSplitMax) - timestamp(klevelStartNaik);    
    dhdt = dh/(dt);
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