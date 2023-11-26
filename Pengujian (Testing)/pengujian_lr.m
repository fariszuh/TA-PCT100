%% KODE REV0 04/06/2023
% Pengujian performa NN
%% READ DATASETS
clc; clear; close all
format compact;

%% PENGUJIAN NN
Vpompa = 10;
Vfc = "var";
Vdrain = "4-10";
lr =  1; % e3

[k_e3,timestamp_e3,MV_volt_FCValve_e3,MV_volt_drain_e3,volt_flow_e3,volt_level_e3,lr_e3,alpha_e3,e_e3] = loadDatasets(Vpompa,Vfc,Vdrain,lr);
% Buat array SP
SP_e3 = zeros(length(k_e3),1);
SP_e3(172:length(k_e3)) = 100; % dalam mm

% Konversi timestamp ms ke detik
timestamp_e3 = timestamp_e3/1000;
% Konversi V_FT ke lt/min
G_FT = 6.940753740463935; % satuan dalam mm3/(Volt.ms)
ltpmin_e3 = G_FT*volt_flow_e3*6*(10^-2);
% Konversi V_LT ke mm
m_LT_inv = 17.518911838790935;
c_LT_inv = 42.177984886649874;
mmlevel_e3 = m_LT_inv*volt_level_e3 + c_LT_inv;

figure; 
subplot(3,1,1);
hold on;
title("Plot h vs k saat lr="+lr);
xlabel("t (detik)");
ylabel("Level (mm)");
plot(timestamp_e3,mmlevel_e3,"DisplayName","y Level");
plot(timestamp_e3,SP_e3,"DisplayName","SP Level")
legend;
hold off;

subplot(3,1,2);
hold on;
title("Plot beban Vdrain vs k saat lr="+lr);
xlabel("t (detik)");
ylabel("Vdrain (Volt)");
plot(timestamp_e3,MV_volt_drain_e3,"DisplayName","Vdrain")
legend;
hold off;

subplot(3,1,3);
hold on;
title("Plot Sinyal Kontrol Valve Vfc vs k saat lr="+lr);
xlabel("t (detik)");
ylabel("Vfc (Volt)");
plot(timestamp_e3,MV_volt_FCValve_e3,"DisplayName","Vfc")
legend;
hold off;

%% LOAD DATASETS
function [k,timestamp,MV_volt_FCValve,MV_volt_drain,volt_flow,volt_level,lr,alpha,e] = loadDatasets(Vpompa,Vfc,Vdrain,lr)
    folderDatasets = "D:\OneDrive - Institut Teknologi Sepuluh Nopember\Tugas Akhir\TA PCT100\Datasets\";
    folderKarakteristik = "Pengujian NN\1 Hidden Layer\";
    src = folderDatasets + folderKarakteristik + Vpompa + "Vpompa_" + Vfc + "Vfc_" + Vdrain + "Vdrain_" + lr + "lr.txt";
    T = readmatrix(src);

    k = T(:,1);
    timestamp = T(:,2);
    MV_volt_FCValve = T(:,3);
    MV_volt_drain = T(:,4);
    volt_flow = T(:,5);
    volt_level = T(:,6);
    lr = T(:,8);
    alpha = T(:,9);
%     SP = T(:,10);
    e = T(:,11);
end