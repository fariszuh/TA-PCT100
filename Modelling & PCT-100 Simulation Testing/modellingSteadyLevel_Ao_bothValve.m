%% KODE REV0 23/05/2023
% Identifikasi gain valve AO manual dan AO proportional valve.
%% READ DATASETS
clc; clear; close all
format compact;

%% MENGHITUNG MODEL FLOW CONTROL VALVE
% Menghitung Ao motor operating valve
% bagus: vpompa=3.25; "versi2_3.5"; 
% Vpompa = "versi3_3";
Vpompa = 10;
% Vpompa = 3.25;
Vfc = 15;
Vdrain = 10;

% Konversi V_FT ke lt/min
[k_2p5Vfc,timestamp_2p5Vfc,MV_volt_FCValve_2p5Vfc,MV_volt_pompa_2p5Vfc,volt_flow_2p5Vfc,volt_level_2p5Vfc] = loadDatasets(Vpompa,Vfc,Vdrain);
G_FT = 6.940753740463935; % satuan dalam mm3/(Volt.ms)
ltpmin_2p5Vfc = G_FT*volt_flow_2p5Vfc*6*(10^-2);
% Konversi V_LT ke mm
m_LT_inv = 17.518911838790935;
c_LT_inv = 42.177984886649874;
mmlevel_2p5Vfc = m_LT_inv*volt_level_2p5Vfc + c_LT_inv;

figure; 
subplot(2,1,1);
hold on;
title("Plot h vs k saat Vpompa="+Vpompa+"V, Vfc="+Vfc+"V, Vdrain="+Vdrain+"V");
xlabel("k");
ylabel("Level (mm)");
plot(k_2p5Vfc,mmlevel_2p5Vfc,"DisplayName","Level");
legend;
hold off;

subplot(2,1,2);
hold on;
title("Plot flow vs k saat Vpompa="+Vpompa+"V, Vfc="+Vfc+"V, Vdrain="+Vdrain+"V");
xlabel("k");
ylabel("Flow (lt/min)");
plot(k_2p5Vfc,ltpmin_2p5Vfc,"DisplayName","Flow")
legend;
hold off;

% split to get steady state value
% indexSplitMin = 11900;
indexSplitMin = 15250;
indexSplitMax = length(k_2p5Vfc); % end, number array element

k_ss = k_2p5Vfc(indexSplitMin:indexSplitMax); % untuk plot ss saja
t_ss = timestamp_2p5Vfc(indexSplitMin:indexSplitMax)/1000; % dalam detik
ltpmin_ss = mean(ltpmin_2p5Vfc(indexSplitMin:indexSplitMax));
m3ps_ss = ltpmin_ss/60000; % konversi lt/min to m3/s, divided by 60000
mmlevel_ss = mean(mmlevel_2p5Vfc(indexSplitMin:indexSplitMax));
meterlevel_ss = mmlevel_ss/1000; % konversi mm to meter, divided by 1000

% split to get actual smooth plot
k_startTime = 500;
k_stopTime = length(k_2p5Vfc);
k_avg = k_2p5Vfc(k_startTime:k_stopTime); % dalam detik
t_avg = timestamp_2p5Vfc(k_startTime:k_stopTime)/1000; % dalam detik

y_plot_mmlevel = mmlevel_2p5Vfc(k_startTime:k_stopTime);
y_plot_ltpmin = ltpmin_2p5Vfc(k_startTime:k_stopTime);

y_plot_mmlevel_ss = mmlevel_ss*ones(length(k_ss),1);
% arr_mmlevel_ss(1:k_parseTime) = []; % 42.177984886649874; % nilai terendah saat ball blm gerak 0V_LT

y_plot_ltpmin_ss = ltpmin_ss*ones(length(k_ss),1);
% arr_ltpmin_ss(1:k_parseTime) = []; % delete element sebelum k_parseTime

% Mencari Ao motor valve
% m_LT = (avg_volt_level(4) - avg_volt_level(1))/(mm_level(4)-mm_level(1));
% c_LT = avg_volt_level(4) - m_LT*mm_level(4);
% disp("V_{LT}(h) = "+ m_LT + " * h " + c_LT);

figure; 
subplot(2,1,1);
hold on;
title("Plot h vs k saat Vpompa="+Vpompa+"V, Vfc="+Vfc+"V, Vdrain="+Vdrain+"V");
xlabel("k");
ylabel("Level (mm)");
plot(k_avg,y_plot_mmlevel,"DisplayName","Level");
plot(k_ss,y_plot_mmlevel_ss,"DisplayName","Average");
legend;
hold off;

subplot(2,1,2);
hold on;
title("Plot flow vs k saat Vpompa="+Vpompa+"V, Vfc="+Vfc+"V, Vdrain="+Vdrain+"V");
xlabel("k");
ylabel("Flow (lt/min)");
plot(k_avg,y_plot_ltpmin,"DisplayName","Flow")
plot(k_ss,y_plot_ltpmin_ss,"DisplayName","Average");
legend;
hold off;


figure; 
subplot(2,1,1);
hold on;
title("Plot h vs t saat Vpompa="+Vpompa+"V, Vfc="+Vfc+"V, Vdrain="+Vdrain+"V");
xlabel("detik");
ylabel("Level (mm)");
plot(t_avg,y_plot_mmlevel,"DisplayName","Level");
plot(t_ss,y_plot_mmlevel_ss,"DisplayName","Average");
legend;
hold off;

subplot(2,1,2);
hold on;
title("Plot flow vs t saat Vpompa="+Vpompa+"V, Vfc="+Vfc+"V, Vdrain="+Vdrain+"V");
xlabel("detik");
ylabel("Flow (lt/min)");
plot(t_avg,y_plot_ltpmin,"DisplayName","Flow")
plot(t_ss,y_plot_ltpmin_ss,"DisplayName","Average");
legend;
hold off;

Ao_both = m3ps_ss / sqrt(2*9.8*meterlevel_ss)
r_tabung = 90; % dalam mm
r_tabung = r_tabung/1000; % dalam meter
A_tabung = pi*r_tabung^2; % dalam m2

b = 1/A_tabung
pole_a = Ao_both*sqrt(2*9.8) / (A_tabung*sqrt(meterlevel_ss))

%% LOAD DATASETS
function [k,timestamp,MV_volt_FCValve,MV_volt_pompa,volt_flow,volt_level] = loadDatasets(Vpompa,Vfc,Vdrain)
    folderDatasets = "D:\OneDrive - Institut Teknologi Sepuluh Nopember\Tugas Akhir\TA PCT100\Datasets\";
%     folderKarakteristik = "with Proportional Drain Valve\Run 16 Menit\";
      folderKarakteristik = "with Both Drain Valve\Run 16 Menit\";
    
%     folderKarakteristik = "with Manual Valve\Run 16 Menit\";
%     folderKarakteristik = "Karakteristik Flow Control Valve\";
%     folderKarakteristik = "Karakteristik Pompa\";

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