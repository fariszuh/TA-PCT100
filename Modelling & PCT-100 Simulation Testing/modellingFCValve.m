%% KODE REV1 11/05/2023
% by Faris 
% respon masih bermasalah
%% READ DATASETS
clc; clear; close all

[k_2V,timestamp_2V,MV_volt_FCValve_2V,MV_volt_pompa_2V,volt_flow_2V,volt_level_2V] = loadDatasets(2,22);
[k_4V,timestamp_4V,MV_volt_FCValve_4V,MV_volt_pompa_4V,volt_flow_4V,volt_level_4V] = loadDatasets(4,22);
[k_6V,timestamp_6V,MV_volt_FCValve_6V,MV_volt_pompa_6V,volt_flow_6V,volt_level_6V] = loadDatasets(6,22);
[k_8V,timestamp_8V,MV_volt_FCValve_8V,MV_volt_pompa_8V,volt_flow_8V,volt_level_8V] = loadDatasets(8,22);
[k_10V,timestamp_10V,MV_volt_FCValve_10V,MV_volt_pompa_10V,volt_flow_10V,volt_level_10V] = loadDatasets(10,22);

% figure, title("Flow Meter vs Input Pompa");
% figure, subplot(2,1,1), title("Flow Meter vs Input Pompa");
% xlabel('k');
% ylabel('V_{FT} (volt)');

% potong array untuk mendapat nilai steady state
indexSplitMin = 1000;
indexSplitMax = 2000;

klevelStartNaik_2V = 1145;
klevelStartNaik_4V = 711;
klevelStartNaik_6V = 544;
klevelStartNaik_8V = 441;
klevelStartNaik_10V = 408;

%% MENGHITUNG MODEL FLOW CONTROL VALVE
G_FT = 6.940753740463935; % satuan dalam mm3/(Volt.ms)
% V_LT(h) = 0.057081 * h -2.4076
% volt ke h: 
% 0.057081170862780, -2.407568761962603
% mengkonversi volt ke mm. eg: mm_level = grad*volt_level + konst

Vpompa = 10;
% Vpompa dijaga tetap, namun tegangan flow valve divariasikan
[k_10Vfc,timestamp_10Vfc,MV_volt_FCValve_10Vfc,MV_volt_pompa_10Vfc,volt_flow_10Vfc,volt_level_10Vfc] = loadDatasets(Vpompa,10);
[k_12Vfc,timestamp_12Vfc,MV_volt_FCValve_12Vfc,MV_volt_pompa_12Vfc,volt_flow_12Vfc,volt_level_12Vfc] = loadDatasets(Vpompa,12);
[k_12p5Vfc,timestamp_12p5Vfc,MV_volt_FCValve_12p5Vfc,MV_volt_pompa_12p5Vfc,volt_flow_12p5Vfc,volt_level_12p5Vfc] = loadDatasets(Vpompa,12.5);
[k_13Vfc,timestamp_13Vfc,MV_volt_FCValve_13Vfc,MV_volt_pompa_13Vfc,volt_flow_13Vfc,volt_level_13Vfc] = loadDatasets(Vpompa,13);
[k_13p5Vfc,timestamp_13p5Vfc,MV_volt_FCValve_13p5Vfc,MV_volt_pompa_13p5Vfc,volt_flow_13p5Vfc,volt_level_13p5Vfc] = loadDatasets(Vpompa,13.5);
[k_14Vfc,timestamp_14Vfc,MV_volt_FCValve_14Vfc,MV_volt_pompa_14Vfc,volt_flow_14Vfc,volt_level_14Vfc] = loadDatasets(Vpompa,14);
[k_14p5Vfc,timestamp_14p5Vfc,MV_volt_FCValve_14p5Vfc,MV_volt_pompa_14p5Vfc,volt_flow_14p5Vfc,volt_level_14p5Vfc] = loadDatasets(Vpompa,14.5);
[k_15Vfc,timestamp_15Vfc,MV_volt_FCValve_15Vfc,MV_volt_pompa_15Vfc,volt_flow_15Vfc,volt_level_15Vfc] = loadDatasets(Vpompa,15);
[k_15p5Vfc,timestamp_15p5Vfc,MV_volt_FCValve_15p5Vfc,MV_volt_pompa_15p5Vfc,volt_flow_15p5Vfc,volt_level_15p5Vfc] = loadDatasets(Vpompa,15.5);
[k_16Vfc,timestamp_16Vfc,MV_volt_FCValve_16Vfc,MV_volt_pompa_16Vfc,volt_flow_16Vfc,volt_level_16Vfc] = loadDatasets(Vpompa,16);
[k_16p5Vfc,timestamp_16p5Vfc,MV_volt_FCValve_16p5Vfc,MV_volt_pompa_16p5Vfc,volt_flow_16p5Vfc,volt_level_16p5Vfc] = loadDatasets(Vpompa,16.5);
[k_17Vfc,timestamp_17Vfc,MV_volt_FCValve_17Vfc,MV_volt_pompa_17Vfc,volt_flow_17Vfc,volt_level_17Vfc] = loadDatasets(Vpompa,17);
[k_17p5Vfc,timestamp_17p5Vfc,MV_volt_FCValve_17p5Vfc,MV_volt_pompa_17p5Vfc,volt_flow_17p5Vfc,volt_level_17p5Vfc] = loadDatasets(Vpompa,17.5);
[k_18Vfc,timestamp_18Vfc,MV_volt_FCValve_18Vfc,MV_volt_pompa_18Vfc,volt_flow_18Vfc,volt_level_18Vfc] = loadDatasets(Vpompa,18);
[k_19Vfc,timestamp_19Vfc,MV_volt_FCValve_19Vfc,MV_volt_pompa_19Vfc,volt_flow_19Vfc,volt_level_19Vfc] = loadDatasets(Vpompa,19);
[k_20Vfc,timestamp_20Vfc,MV_volt_FCValve_20Vfc,MV_volt_pompa_20Vfc,volt_flow_20Vfc,volt_level_20Vfc] = loadDatasets(Vpompa,20);
[k_21Vfc,timestamp_21Vfc,MV_volt_FCValve_21Vfc,MV_volt_pompa_21Vfc,volt_flow_21Vfc,volt_level_21Vfc] = loadDatasets(Vpompa,21);
[k_22Vfc,timestamp_22Vfc,MV_volt_FCValve_22Vfc,MV_volt_pompa_22Vfc,volt_flow_22Vfc,volt_level_22Vfc] = loadDatasets(Vpompa,22);

ltpmin_10Vfc = G_FT*volt_flow_10Vfc*6*(10^-2);
ltpmin_12Vfc = G_FT*volt_flow_12Vfc*6*(10^-2);
ltpmin_12p5Vfc = G_FT*volt_flow_12p5Vfc*6*(10^-2);
ltpmin_13Vfc = G_FT*volt_flow_13Vfc*6*(10^-2);
ltpmin_13p5Vfc = G_FT*volt_flow_13p5Vfc*6*(10^-2);
ltpmin_14Vfc = G_FT*volt_flow_14Vfc*6*(10^-2);
ltpmin_14p5Vfc = G_FT*volt_flow_14p5Vfc*6*(10^-2);
ltpmin_15Vfc = G_FT*volt_flow_15Vfc*6*(10^-2);
ltpmin_15p5Vfc = G_FT*volt_flow_15p5Vfc*6*(10^-2);
ltpmin_16Vfc = G_FT*volt_flow_16Vfc*6*(10^-2);
ltpmin_16p5Vfc = G_FT*volt_flow_16p5Vfc*6*(10^-2);
ltpmin_17Vfc = G_FT*volt_flow_17Vfc*6*(10^-2);
ltpmin_17p5Vfc = G_FT*volt_flow_17p5Vfc*6*(10^-2);
ltpmin_18Vfc = G_FT*volt_flow_18Vfc*6*(10^-2);
ltpmin_19Vfc = G_FT*volt_flow_19Vfc*6*(10^-2);
ltpmin_20Vfc = G_FT*volt_flow_20Vfc*6*(10^-2);



ltpmin_21Vfc = G_FT*volt_flow_21Vfc*6*(10^-2);
ltpmin_22Vfc = G_FT*volt_flow_22Vfc*6*(10^-2);

figure, title("Plot FC Valve saat Vpompa=" + Vpompa + "V vs k");
hold on;
xlabel("k");
ylabel("Flow rate (lt/min)");
plot(k_10Vfc,ltpmin_10Vfc,"DisplayName","Vfc=10V");
plot(k_12Vfc,ltpmin_12Vfc,"DisplayName","Vfc=12V");
plot(k_12p5Vfc,ltpmin_12p5Vfc,"DisplayName","Vfc=12.5V");
plot(k_13Vfc,ltpmin_13Vfc,"DisplayName","Vfc=13V");
plot(k_13p5Vfc,ltpmin_13p5Vfc,"DisplayName","Vfc=13.5V");
plot(k_14Vfc,ltpmin_14Vfc,"DisplayName","Vfc=14V");
plot(k_14p5Vfc,ltpmin_14p5Vfc,"DisplayName","Vfc=14.5V");
plot(k_15Vfc,ltpmin_15Vfc,"DisplayName","Vfc=15V");
plot(k_15p5Vfc,ltpmin_15p5Vfc,"DisplayName","Vfc=15.5V");
plot(k_16Vfc,ltpmin_16Vfc,"DisplayName","Vfc=16V");
plot(k_16p5Vfc,ltpmin_16p5Vfc,"DisplayName","Vfc=16.5V");
plot(k_17Vfc,ltpmin_17Vfc,"DisplayName","Vfc=17V");
plot(k_17p5Vfc,ltpmin_17p5Vfc,"DisplayName","Vfc=17.5V");
plot(k_18Vfc,ltpmin_18Vfc,"DisplayName","Vfc=18V");
plot(k_19Vfc,ltpmin_19Vfc,"DisplayName","Vfc=19V");
plot(k_20Vfc,ltpmin_20Vfc,"DisplayName","Vfc=20V");
plot(k_21Vfc,ltpmin_21Vfc,"DisplayName","Vfc=21V");
plot(k_22Vfc,ltpmin_22Vfc,"DisplayName","Vfc=22V");

legend;

format compact;
SI_10Vfc = stepinfo(ltpmin_10Vfc(indexSplitMin:indexSplitMax));
SI_10Vfc_ss = mean([SI_10Vfc.SettlingMin,SI_10Vfc.SettlingMax])
SI_12Vfc = stepinfo(ltpmin_12Vfc(indexSplitMin:indexSplitMax));
SI_12Vfc_ss = mean([SI_12Vfc.SettlingMin,SI_12Vfc.SettlingMax])
SI_12p5Vfc = stepinfo(ltpmin_12p5Vfc(indexSplitMin:indexSplitMax));
SI_12p5Vfc_ss = mean([SI_12p5Vfc.SettlingMin,SI_12p5Vfc.SettlingMax])
SI_13Vfc = stepinfo(ltpmin_13Vfc(indexSplitMin:indexSplitMax));
SI_13Vfc_ss = mean([SI_13Vfc.SettlingMin,SI_13Vfc.SettlingMax])
SI_13p5Vfc = stepinfo(ltpmin_13p5Vfc(indexSplitMin:indexSplitMax));
SI_13p5Vfc_ss = mean([SI_13p5Vfc.SettlingMin,SI_13p5Vfc.SettlingMax])
SI_14Vfc = stepinfo(ltpmin_14Vfc(indexSplitMin:indexSplitMax));
SI_14Vfc_ss = mean([SI_14Vfc.SettlingMin,SI_14Vfc.SettlingMax])
SI_14p5Vfc = stepinfo(ltpmin_14p5Vfc(indexSplitMin:indexSplitMax));
SI_14p5Vfc_ss = mean([SI_14p5Vfc.SettlingMin,SI_14p5Vfc.SettlingMax])
SI_15Vfc = stepinfo(ltpmin_15Vfc(indexSplitMin:indexSplitMax));
SI_15Vfc_ss = mean([SI_15Vfc.SettlingMin,SI_15Vfc.SettlingMax])
SI_15p5Vfc = stepinfo(ltpmin_15p5Vfc(indexSplitMin:indexSplitMax));
SI_15p5Vfc_ss = mean([SI_15p5Vfc.SettlingMin,SI_15p5Vfc.SettlingMax])
SI_16Vfc = stepinfo(ltpmin_16Vfc(indexSplitMin:indexSplitMax));
SI_16Vfc_ss = mean([SI_16Vfc.SettlingMin,SI_16Vfc.SettlingMax])
SI_16p5Vfc = stepinfo(ltpmin_16p5Vfc(indexSplitMin:indexSplitMax));
SI_16p5Vfc_ss = mean([SI_16p5Vfc.SettlingMin,SI_16p5Vfc.SettlingMax])
SI_17Vfc = stepinfo(ltpmin_17Vfc(indexSplitMin:indexSplitMax));
SI_17Vfc_ss = mean([SI_17Vfc.SettlingMin,SI_17Vfc.SettlingMax])
SI_17p5Vfc = stepinfo(ltpmin_17p5Vfc(indexSplitMin:indexSplitMax));
SI_17p5Vfc_ss = mean([SI_17p5Vfc.SettlingMin,SI_17p5Vfc.SettlingMax])
SI_18Vfc = stepinfo(ltpmin_18Vfc(indexSplitMin:indexSplitMax));
SI_18Vfc_ss = mean([SI_18Vfc.SettlingMin,SI_18Vfc.SettlingMax])

SI_19Vfc = stepinfo(ltpmin_19Vfc(indexSplitMin:indexSplitMax));
SI_19Vfc_ss = mean([SI_19Vfc.SettlingMin,SI_19Vfc.SettlingMax])

SI_20Vfc = stepinfo(ltpmin_20Vfc(indexSplitMin:indexSplitMax));
SI_20Vfc_ss = mean([SI_20Vfc.SettlingMin,SI_20Vfc.SettlingMax])

SI_21Vfc = stepinfo(ltpmin_21Vfc(indexSplitMin:indexSplitMax));
SI_21Vfc_ss = mean([SI_21Vfc.SettlingMin,SI_21Vfc.SettlingMax])

SI_22Vfc = stepinfo(ltpmin_22Vfc(indexSplitMin:indexSplitMax));
SI_22Vfc_ss = mean([SI_22Vfc.SettlingMin,SI_22Vfc.SettlingMax])

% plot(k_10Vfc,ones(length(k_10Vfc),1)*SI_10Vfc_ss);
% plot(k_12Vfc,ones(length(k_12Vfc),1)*SI_12Vfc_ss);
% plot(k_12p5Vfc,ones(length(k_12p5Vfc),1)*SI_12p5Vfc_ss);
% plot(k_13Vfc,ones(length(k_13Vfc),1)*SI_13Vfc_ss);
% plot(k_13p5Vfc,ones(length(k_13p5Vfc),1)*SI_13p5Vfc_ss);
% plot(k_14Vfc,ones(length(k_14Vfc),1)*SI_14Vfc_ss);
% plot(k_14p5Vfc,ones(length(k_14p5Vfc),1)*SI_14p5Vfc_ss);
% plot(k_15Vfc,ones(length(k_15Vfc),1)*SI_15Vfc_ss);
% plot(k_15p5Vfc,ones(length(k_15p5Vfc),1)*SI_15p5Vfc_ss);
% plot(k_16Vfc,ones(length(k_16Vfc),1)*SI_16Vfc_ss);
% plot(k_16p5Vfc,ones(length(k_16p5Vfc),1)*SI_16p5Vfc_ss);
% plot(k_17Vfc,ones(length(k_17Vfc),1)*SI_17Vfc_ss);
% plot(k_17p5Vfc,ones(length(k_17p5Vfc),1)*SI_17p5Vfc_ss);
% plot(k_18Vfc,ones(length(k_18Vfc),1)*SI_18Vfc_ss);
% plot(k_19Vfc,ones(length(k_19Vfc),1)*SI_19Vfc_ss);
% plot(k_20Vfc,ones(length(k_20Vfc),1)*SI_20Vfc_ss);
% plot(k_21Vfc,ones(length(k_21Vfc),1)*SI_21Vfc_ss);
% plot(k_22Vfc,ones(length(k_22Vfc),1)*SI_22Vfc_ss);
hold off;

arr_SI_Vfc = [SI_10Vfc_ss, SI_12Vfc_ss, SI_12p5Vfc_ss, SI_13Vfc_ss, SI_13p5Vfc_ss,...
                SI_14Vfc_ss, SI_14p5Vfc_ss, SI_15Vfc_ss, SI_15p5Vfc_ss, SI_16Vfc_ss,...
                SI_16p5Vfc_ss, SI_17Vfc_ss, SI_17p5Vfc_ss SI_18Vfc_ss,...
                SI_19Vfc_ss, SI_20Vfc_ss, SI_21Vfc_ss, SI_22Vfc_ss];
arr_Vfc = [10,12,12.5,13,13.5,14,14.5,15,15.5,16,16.5,17,17.5,18,19,20,21,22];

figure, title("Plot FC Valve vs Vfc");
hold on;
xlabel("Vfc (Volt)");
ylabel("Flow rate (lt/min)");
scatter(arr_Vfc,arr_SI_Vfc);
hold off;

syms s;
s = tf('s');
u_Vfc = 21; % dalam volt
K = 0.1459;
Tdv1 = 9.667*10^-4;
tau_v1 = 0.001;
Gv1 = K*exp(-1*Tdv1*s)/(tau_v1*s + 1);

[ltpmin_model,t_model] = step(Gv1*u_Vfc,116.35);
timestamp_21Vfc_menit = linspace(0,max(k_21Vfc)*0.05,length(k_21Vfc)); % dalam detik
timestamp_21Vfc_menit = timestamp_21Vfc_menit(1:1600)/60;

figure; title("ZN Identification 21Vfc");
hold on;
xlabel("t (Menit)");
ylabel("Flow rate (lt/min)");
plot(timestamp_21Vfc_menit,ltpmin_21Vfc(1:1600),"DisplayName","Datasets");
plot(t_model/60, ltpmin_model,"DisplayName","Model");
legend;
hold off;
% SI_12p5Vfc.SettlingMin
% SI_12p5Vfc.SettlingMax
%% LOAD DATASETS
function [k,timestamp,MV_volt_FCValve,MV_volt_pompa,volt_flow,volt_level] = loadDatasets(Vpompa,Vfc)
    folderDatasets = "D:\OneDrive - Institut Teknologi Sepuluh Nopember\Tugas Akhir\TA PCT100\Datasets\";
    folderKarakteristik = "Karakteristik Flow Control Valve\";
%     folderKarakteristik = "Karakteristik Pompa\";
    src = folderDatasets + folderKarakteristik + Vpompa + "Vpompa_" + Vfc + "Vfc.txt";
    T = readmatrix(src);
    k = T(:,1);  
    timestamp = T(:,2);
    % revisi, sambung hitungan karena datasets terbatas max 65535 uint16_t
%     for t=1:length(timestamp)
%         if t == 1
%             continue; % skipped in first loop
%         else
%             diff = timestamp(t) - timestamp(t-1);
%             % jika diff (selisih) timestamp dengan sebelumnya negatif, maka
%             % harus ditambah dengan lastValue (nilai bit overflow)
%             if diff < 0
%                 if Vpompa == 2
%                     lastValue = 65521;
%                 elseif Vpompa == 4
%                     lastValue = 65533;
%                 elseif Vpompa == 6
%                     lastValue = 65526;
%                 elseif Vpompa == 8
%                     lastValue = 65494;
%                 elseif Vpompa == 10
%                     lastValue = 65506;
%                 end
%             else
%                 lastValue = 0;
%                 overflowTime = t;
%             end
%             timestamp(t) = timestamp(t) + lastValue;
%         end
%     end
    
    MV_volt_FCValve = T(:,3);
    MV_volt_pompa = T(:,4);
    bit_flow = T(:,5);
    bit_level = T(:,6);

    % scaling langsung dikali 10V bukan 3.3V, karena sudah dlm bentuk bit
    volt_flow = bit_flow * 10 / 4096; 
    volt_level = bit_level * 10 / 4096;
end