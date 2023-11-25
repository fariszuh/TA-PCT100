%% READ DATASETS
clc; clear; close all
% syntax: Vpompa,Vfc,Vdrain
% Vpompa dan Vfc dibuat konstan, Vdrain divariasikan
[k_2Vd,timestamp_2Vd,MV_volt_FCValve_2Vd,MV_volt_pompa_2Vd,volt_flow_2Vd,volt_level_2Vd] = loadDatasets(10,18,2);
[k_4Vd,timestamp_4Vd,MV_volt_FCValve_4Vd,MV_volt_pompa_4Vd,volt_flow_4Vd,volt_level_4Vd] = loadDatasets(10,18,4);
[k_6Vd,timestamp_6Vd,MV_volt_FCValve_6Vd,MV_volt_pompa_6Vd,volt_flow_6Vd,volt_level_6Vd] = loadDatasets(10,18,6);
[k_8Vd,timestamp_8Vd,MV_volt_FCValve_8Vd,MV_volt_pompa_8Vd,volt_flow_8Vd,volt_level_8Vd] = loadDatasets(10,18,8);
[k_10Vd,timestamp_10Vd,MV_volt_FCValve_10Vd,MV_volt_pompa_10Vd,volt_flow_10Vd,volt_level_10Vd] = loadDatasets(10,18,10);
% Vpompa dan Vdrain dibuat konstan, Vfc divariasikan
[k_22Vfc,timestamp_22Vfc,MV_volt_FCValve_22Vfc,MV_volt_pompa_22Vfc,volt_flow_22Vfc,volt_level_22Vfc] = loadDatasets(10,22,2);
[k_18Vfc,timestamp_18Vfc,MV_volt_FCValve_18Vfc,MV_volt_pompa_18Vfc,volt_flow_18Vfc,volt_level_18Vfc] = loadDatasets(10,18,2);
% [k_16Vfc,timestamp_16Vfc,MV_volt_FCValve_16Vfc,MV_volt_pompa_16Vfc,volt_flow_16Vfc,volt_level_16Vfc] = loadDatasets(10,16,2)
[k_15Vfc,timestamp_15Vfc,MV_volt_FCValve_15Vfc,MV_volt_pompa_15Vfc,volt_flow_15Vfc,volt_level_15Vfc] = loadDatasets(10,15,2);
[k_14Vfc,timestamp_14Vfc,MV_volt_FCValve_14Vfc,MV_volt_pompa_14Vfc,volt_flow_14Vfc,volt_level_14Vfc] = loadDatasets(10,14,2);
% Konversi V_FT ke lt/min
G_FT = 6.940753740463935; % satuan dalam mm3/(Volt.ms)
ltpmin_2Vd = G_FT*volt_flow_2Vd*6*(10^-2);
ltpmin_4Vd = G_FT*volt_flow_4Vd*6*(10^-2);
ltpmin_6Vd = G_FT*volt_flow_6Vd*6*(10^-2);
ltpmin_8Vd = G_FT*volt_flow_8Vd*6*(10^-2);
ltpmin_10Vd = G_FT*volt_flow_10Vd*6*(10^-2);

ltpmin_22Vfc = G_FT*volt_flow_22Vfc*6*(10^-2);
ltpmin_18Vfc = G_FT*volt_flow_18Vfc*6*(10^-2);
% ltpmin_16Vfc = G_FT*volt_flow_16Vfc*6*(10^-2);
ltpmin_15Vfc = G_FT*volt_flow_15Vfc*6*(10^-2);
ltpmin_14Vfc = G_FT*volt_flow_14Vfc*6*(10^-2);
% Konversi V_LT ke mm
m_LT_inv = 17.518911838790935;
c_LT_inv = 42.177984886649874;
mm_level_2Vd = m_LT_inv*volt_level_2Vd + c_LT_inv;
mm_level_4Vd = m_LT_inv*volt_level_4Vd + c_LT_inv;
mm_level_6Vd = m_LT_inv*volt_level_6Vd + c_LT_inv;
mm_level_8Vd = m_LT_inv*volt_level_8Vd + c_LT_inv;
mm_level_10Vd = m_LT_inv*volt_level_10Vd + c_LT_inv;

mm_level_22Vfc = m_LT_inv*volt_level_22Vfc + c_LT_inv;
mm_level_18Vfc = m_LT_inv*volt_level_18Vfc + c_LT_inv;
% mm_level_16Vfc = m_LT_inv*volt_level_16Vfc + c_LT_inv;
mm_level_15Vfc = m_LT_inv*volt_level_15Vfc + c_LT_inv;
mm_level_14Vfc = m_LT_inv*volt_level_14Vfc + c_LT_inv;
% PLOT FLOW
figure, title("(Flow) Variasi Vdrain saat Vpompa=10V, Vfc=22V");
hold on;
xlabel("k");
ylabel("Flow rate (lt/min)");
plot(k_2Vd,ltpmin_2Vd,"DisplayName","Vd=2V");
plot(k_4Vd,ltpmin_4Vd,"DisplayName","Vd=4V");
plot(k_6Vd,ltpmin_6Vd,"DisplayName","Vd=6V");
plot(k_8Vd,ltpmin_8Vd,"DisplayName","Vd=8V");
plot(k_10Vd,ltpmin_10Vd,"DisplayName","Vd=10V");
legend;
hold off;

figure, title("(Flow) Variasi Vfc saat Vpompa=10V, Vdrain=2V");
hold on;
xlabel("k");
ylabel("Flow rate (lt/min)");
plot(k_22Vfc,ltpmin_22Vfc,"DisplayName","Vfc=22V");
plot(k_18Vfc,ltpmin_18Vfc,"DisplayName","Vfc=18V");
% plot(k_16Vfc,ltpmin_16Vfc,"DisplayName","Vfc=16V");
plot(k_15Vfc,ltpmin_15Vfc,"DisplayName","Vfc=15V");
plot(k_14Vfc,ltpmin_14Vfc,"DisplayName","Vfc=14V");
legend;
hold off;
% PLOT LEVEL
figure, title("(Level) Variasi Vdrain saat Vpompa=10V, Vfc=18V");
hold on;
xlabel("k");
ylabel("Tank Level (mm)");
plot(k_2Vd,mm_level_2Vd,"DisplayName","Vd=2V");
plot(k_4Vd,mm_level_4Vd,"DisplayName","Vd=4V");
plot(k_6Vd,mm_level_6Vd,"DisplayName","Vd=6V");
plot(k_8Vd,mm_level_8Vd,"DisplayName","Vd=8V");
plot(k_10Vd,mm_level_10Vd,"DisplayName","Vd=10V");
legend;
hold off;

figure, title("(Level) Variasi Vdrain saat Vpompa=10V, Vfc=18V");
hold on;
xlabel("t (detik)");
ylabel("Tank Level (mm)");
plot(timestamp_2Vd/1000,mm_level_2Vd,"DisplayName","Vdrain=2V");
% plot(timestamp_4Vd/1000,mm_level_4Vd,"DisplayName","Vdrain=4V");
% plot(timestamp_6Vd/1000,mm_level_6Vd,"DisplayName","Vdrain=6V");
% plot(timestamp_8Vd/1000,mm_level_8Vd,"DisplayName","Vdrain=8V");
% plot(timestamp_10Vd/1000,mm_level_10Vd,"DisplayName","Vdrain=10V");
% legend;
hold off;

figure, title("(Level) Variasi Vfc saat Vpompa=10V, Vdrain=2V");
hold on;
xlabel("k");
ylabel("Tank Level (mm)");
plot(k_22Vfc,mm_level_22Vfc,"DisplayName","Vfc=22V");
plot(k_18Vfc,mm_level_18Vfc,"DisplayName","Vfc=18V");
% plot(k_16Vfc,mm_level_16Vfc,"DisplayName","Vfc=16V");
plot(k_15Vfc,mm_level_15Vfc,"DisplayName","Vfc=15V");
plot(k_14Vfc,mm_level_14Vfc,"DisplayName","Vfc=14V");
legend;
hold off;

%% ARX IDENTIFICATION
datasets_14Vfc = iddata(ltpmin_14Vfc(1:2119),MV_volt_FCValve_14Vfc(1:2119),0.05); % Ts = 50ms
datasets_15Vfc = iddata(ltpmin_15Vfc(1:2119),MV_volt_FCValve_15Vfc(1:2119),0.05); % Ts = 50ms
datasets_18Vfc = iddata(ltpmin_18Vfc(1:2119),MV_volt_FCValve_18Vfc(1:2119),0.05); % Ts = 50ms
datasets_22Vfc = iddata(ltpmin_22Vfc(1:2119),MV_volt_FCValve_22Vfc(1:2119),0.05); % Ts = 50ms
sys_14Vfc = armax(datasets_14Vfc, [3 3 1 0]);
sys_15Vfc = armax(datasets_15Vfc, [3 3 1 0]);
sys_18Vfc = armax(datasets_18Vfc, [3 3 1 0]); % best fit: [3 3 1 0],[3 3 0 0]
sys_22Vfc = armax(datasets_22Vfc, [3 3 1 0]);

figure, title("Comparing Datasets with ARMAX");
hold on;
xlabel("k");
ylabel("Flow (lt/min)");
compare(datasets_14Vfc,sys_14Vfc);
% compare(datasets_15Vfc,sys_15Vfc);
% compare(datasets_18Vfc,sys_18Vfc);
% compare(datasets_22Vfc,sys_22Vfc);
legend;
hold off;

figure, title("Comparing Datasets with ARMAX");
hold on;
xlabel("k");
ylabel("Flow (lt/min)");
% compare(datasets_14Vfc,sys_14Vfc);
compare(datasets_15Vfc,sys_15Vfc);
% compare(datasets_18Vfc,sys_18Vfc);
% compare(datasets_22Vfc,sys_22Vfc);
legend;
hold off;

figure, title("Comparing Datasets with ARMAX");
hold on;
xlabel("k");
ylabel("Flow (lt/min)");
% compare(datasets_14Vfc,sys_14Vfc);
% compare(datasets_15Vfc,sys_15Vfc);
compare(datasets_18Vfc,sys_18Vfc);
% compare(datasets_22Vfc,sys_22Vfc);
legend;
hold off;

figure, title("Comparing Datasets with ARMAX");
hold on;
xlabel("k");
ylabel("Flow (lt/min)");
% compare(datasets_14Vfc,sys_14Vfc);
% compare(datasets_15Vfc,sys_15Vfc);
% compare(datasets_18Vfc,sys_18Vfc);
compare(datasets_22Vfc,sys_22Vfc);
legend;
hold off;
%% LOAD DATASETS
function [k,timestamp,MV_volt_FCValve,MV_volt_pompa,volt_flow,volt_level] = loadDatasets(Vpompa,Vfc,Vdrain)
    folderDatasets = "D:\OneDrive - Institut Teknologi Sepuluh Nopember\Tugas Akhir\TA PCT100\Datasets\";
%     folderKarakteristik = "Karakteristik Flow Control Valve\";
%     folderKarakteristik = "Karakteristik Pompa\";
    folderKarakteristik = "Karakteristik Drain Valve\";
    src = folderDatasets + folderKarakteristik + Vpompa + "Vpompa_" + Vfc + "Vfc_" + Vdrain + "Vdrain.txt";
    T = readmatrix(src);
    k = T(:,1);  
    timestamp = T(:,2);
    MV_volt_FCValve = T(:,3);
    MV_volt_pompa = T(:,4);
    bit_flow = T(:,5);
    bit_level = T(:,6);
    % scaling langsung dikali 10V bukan 3.3V, karena sudah dlm bentuk bit
    volt_flow = bit_flow * 10 / 4096; 
    volt_level = bit_level * 10 / 4096;
end