%% KODE REV0 23/05/2023
% Identifikasi gain valve AO manual dan AO proportional valve.
%% READ DATASETS
clc; clear; close all
format compact;

%% MENGHITUNG MODEL FLOW CONTROL VALVE
% Menghitung Ao manual drain valve

% Vpompa = "versi2_3.5";
Vpompa = 2.5;
Vfc = 15;
Vdrain = 0;

% Konversi V_FT ke lt/min
[k_2p5Vfc_ori,timestamp_2p5Vfc_ori,MV_volt_FCValve_2p5Vfc_ori,MV_volt_pompa_2p5Vfc_ori,volt_flow_2p5Vfc_ori,volt_level_2p5Vfc_ori] = loadDatasets(Vpompa,Vfc,Vdrain);
% hapus data NaN, tapi buat k_2p5Vfc baru
indexNaN = isnan(k_2p5Vfc_ori) | isnan(volt_flow_2p5Vfc_ori) | isnan(volt_level_2p5Vfc_ori);
k_2p5Vfc = [];
timestamp_2p5Vfc = [];
MV_volt_FCValve_2p5Vfc = [];
MV_volt_pompa_2p5Vfc = [];
volt_flow_2p5Vfc = [];
volt_level_2p5Vfc = [];
loop_time = 0;
loop_k = 1;
for k=1:length(k_2p5Vfc_ori)
    if(k < 53)
        continue; % skip initial start step time
    end
    if(indexNaN(k) == 0)
        k_2p5Vfc = [k_2p5Vfc; loop_k];
        timestamp_2p5Vfc = [timestamp_2p5Vfc; loop_time];
        MV_volt_FCValve_2p5Vfc = [MV_volt_FCValve_2p5Vfc; MV_volt_FCValve_2p5Vfc_ori(k)];
        MV_volt_pompa_2p5Vfc = [MV_volt_pompa_2p5Vfc; MV_volt_pompa_2p5Vfc_ori(k)];
        volt_flow_2p5Vfc = [volt_flow_2p5Vfc; volt_flow_2p5Vfc_ori(k)];
        volt_level_2p5Vfc = [volt_level_2p5Vfc; volt_level_2p5Vfc_ori(k)];
        loop_k = loop_k + 1;
        loop_time = loop_time + 50; % dalam ms
    end
end
% k_2p5Vfc = 1:length(k_2p5Vfc);
G_FT = 6.940753740463935; % satuan dalam mm3/(Volt.ms)
ltpmin_2p5Vfc = G_FT*volt_flow_2p5Vfc*6*(10^-2);

m3ps_2p5Vfc = ltpmin_2p5Vfc/60000;
% Konversi V_LT ke mm
m_LT_inv = 17.518911838790935;
c_LT_inv = 42.177984886649874;
mmlevel_2p5Vfc = m_LT_inv*volt_level_2p5Vfc + c_LT_inv;
meterlevel_2p5Vfc = mmlevel_2p5Vfc/1000;

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
indexSplitMin = 15911-53;
indexSplitMax = 17200-53;

k_ss = k_2p5Vfc(indexSplitMin:indexSplitMax); % untuk plot ss saja
t_ss = timestamp_2p5Vfc(indexSplitMin:indexSplitMax)/1000; % dalam detik
ltpmin_ss = mean(ltpmin_2p5Vfc(indexSplitMin:indexSplitMax));
m3ps_ss = ltpmin_ss/60000; % konversi lt/min to m3/s, divided by 60000
mmlevel_ss = mean(mmlevel_2p5Vfc(indexSplitMin:indexSplitMax));
meterlevel_ss = mmlevel_ss/1000; % konversi mm to meter, divided by 1000

% split to get actual smooth plot
k_startTime = 2200-53;
k_stopTime = 17200-53;
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

Ao_man = m3ps_ss / sqrt(2*9.8*meterlevel_ss)
r_tabung = 80; % dalam mm
r_tabung = r_tabung/1000; % dalam meter
A_tabung = pi*r_tabung^2; % dalam m2

b = 1/A_tabung;
pole_a = Ao_man*sqrt(2*9.8) / (A_tabung*sqrt(meterlevel_ss));

K = meterlevel_ss/m3ps_ss;
y865 = mmlevel_ss*0.865
% y95 = mmlevel_ss*0.95
% y982 = mmlevel_ss*0.982
t865 = timestamp_2p5Vfc(9613)/1000 % baca dari kurva, dalam detik
% t982 = timestamp_2p5Vfc(14490)/1000
% t95 = timestamp_2p5Vfc(12888)/1000
tau = t865/2; % 86.5% yss berada saat 2T
% tau = t95/3
% tau = t982/4

syms s;
s = tf('s');
sys_c = tf([b],[1 pole_a])
% sys_c = tf([K],[tau 1])
u = 1.6132*10^-5; % dalam m3/s
% u_lsim = zeros(length(timestamp_2p5Vfc),1);
% u_lsim(54:length(u_lsim))= u*ones(length(u_lsim)-54+1,1);

% t_lsim = linspace(0,max(timestamp_2p5Vfc/1000),length(y_sysid));
t_lsim = timestamp_2p5Vfc(1:k_stopTime)/1000; % dalam s
u_lsim = u*ones(length(t_lsim),1);
[y_model,t_model] = lsim(sys_c,u_lsim,t_lsim);
y_model_mmlevel = y_model*1000; % konversi meter ke mm

y_plot_mmlevel_mse = y_plot_mmlevel(4877:end);
y_model_mse = y_model_mmlevel(4877+2200-54:end);

% mse = 0.5*sum((y_plot_mmlevel_mse - y_model_mse).^2)
% 
% figure;
% title("Comparison datasets vs estimation");
% hold on;
% plot(t_avg,y_plot_mmlevel,"DisplayName","Datasets");
% plot(t_model,y_model_mmlevel,"DisplayName","Estimation by Formula")
% legend
% hold off;

% sim("closedLoop",1000);

%% Harus Run simulink openLoop dulu untuk dapat data dan hanya RUN SECTION ini, agar workspace clear all section awal tdk berjalan.
y_model_simulink = out.h_simulink;
y_model_1storder = out.h_1storder;
t_model_mmlevel = out.tout;

% y_datasets = y_plot_mmlevel(3645:15001);
% t_datasets = t_avg(3645:15001);
% y_model = y_model_mmlevel(3645:15001);
% t_model = t_model_mmlevel(3645:15001);

figure;
title("Perbandingan Datasets vs Estimasi saat Manual Valve Full Open");
hold on;
xlabel("t (detik)");
ylabel("Level (mm)");
plot(t_avg,y_plot_mmlevel,"DisplayName","Datasets");
plot(t_model_mmlevel,y_model_simulink,"DisplayName","Estimation by Simulink");
plot(t_model_mmlevel,y_model_1storder,"DisplayName","Estimation by TF");
legend
hold off;
% dari kurva tsb. tampak selisih terbesar yplot dan ymodel ialah 55-50=5mm,
% dapat diabaikan, error pengukuran 5mm
y_datasets = y_plot_mmlevel(1487:14995);
t_datasets = t_avg(1487:14995);
y_model = y_model_mmlevel(3638:end);
t_model = t_model_mmlevel(3638:end);

mse = 0.5*sum((y_datasets - y_model).^2)/length(y_datasets)
%% LOAD DATASETS
function [k,timestamp,MV_volt_FCValve,MV_volt_pompa,volt_flow,volt_level] = loadDatasets(Vpompa,Vfc,Vdrain)
    folderDatasets = "D:\OneDrive - Institut Teknologi Sepuluh Nopember\Tugas Akhir\TA PCT100\Datasets\";
%     folderKarakteristik = "with Proportional Drain Valve\Run 16 Menit\";
%       folderKarakteristik = "with Both Drain Valve\Run 16 Menit\";
    
    folderKarakteristik = "with Manual Valve\Run 16 Menit\";
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